terraform {
  required_providers {
    google = {
      source  = "hashicorp/google"
      version = "~> 5.0"
    }
    archive = {
      source  = "hashicorp/archive"
      version = "~> 2.4"
    }
  }
}

provider "google" {
  project = var.project_id
  region  = var.region
}

variable "project_id" {
  description = "The GCP Project ID"
  type        = string
}

variable "region" {
  description = "The GCP region to deploy resources to"
  type        = string
  default     = "europe-west3" # Adjust as needed
}

# ==============================================================================
# 1. ENABLE REQUIRED APIS
# ==============================================================================
locals {
  services = [
    "cloudfunctions.googleapis.com",
    "cloudbuild.googleapis.com",
    "eventarc.googleapis.com",
    "run.googleapis.com",
    "storage.googleapis.com",
    "aiplatform.googleapis.com" # Required for Vertex AI (Gemini)
  ]
}

resource "google_project_service" "enabled_apis" {
  for_each                   = toset(local.services)
  service                    = each.key
  disable_dependent_services = true
  disable_on_destroy         = false
}

# ==============================================================================
# 2. CLOUD STORAGE BUCKETS
# ==============================================================================
resource "random_id" "bucket_prefix" {
  byte_length = 4
}

# Input Bucket: Where CV PDFs get uploaded
resource "google_storage_bucket" "cv_input_bucket" {
  name                        = "cv-input-${random_id.bucket_prefix.hex}"
  location                    = var.region
  uniform_bucket_level_access = true
  force_destroy               = true
}

# Output Bucket: Where the summary PDFs are saved
resource "google_storage_bucket" "summary_output_bucket" {
  name                        = "cv-summary-output-${random_id.bucket_prefix.hex}"
  location                    = var.region
  uniform_bucket_level_access = true
  force_destroy               = true
}

# Source Code Bucket: For Cloud Functions deployments
resource "google_storage_bucket" "function_source_bucket" {
  name                        = "function-source-${random_id.bucket_prefix.hex}"
  location                    = var.region
  uniform_bucket_level_access = true
  force_destroy               = true
}

# ==============================================================================
# 3. ZIP AND UPLOAD FUNCTION SOURCE CODE
# ==============================================================================
data "archive_file" "function_zip" {
  type        = "zip"
  source_dir  = "${path.module}/src"
  output_path = "${path.module}/function-source.zip"
}

resource "google_storage_bucket_object" "function_source" {
  name   = "source-${data.archive_file.function_zip.output_md5}.zip"
  bucket = google_storage_bucket.function_source_bucket.name
  source = data.archive_file.function_zip.output_path
}

# ==============================================================================
# 4. IAM & SERVICE ACCOUNTS
# ==============================================================================

# Create a dedicated Service Account for the Cloud Function
resource "google_service_account" "function_sa" {
  account_id   = "cv-processor-sa"
  display_name = "CV Processor Function Service Account"
}

# Allow Function SA to READ the uploaded CVs from the Input Bucket
resource "google_storage_bucket_iam_member" "sa_read_input" {
  bucket = google_storage_bucket.cv_input_bucket.name
  role   = "roles/storage.objectViewer"
  member = "serviceAccount:${google_service_account.function_sa.email}"
}

# Allow Function SA to WRITE the generated summary PDFs to the Output Bucket
resource "google_storage_bucket_iam_member" "sa_write_output" {
  bucket = google_storage_bucket.summary_output_bucket.name
  role   = "roles/storage.objectUser"
  member = "serviceAccount:${google_service_account.function_sa.email}"
}

# Give the Function SA permission to receive Eventarc events
resource "google_project_iam_member" "eventarc_receiver" {
  project = var.project_id
  role    = "roles/eventarc.eventReceiver"
  member  = "serviceAccount:${google_service_account.function_sa.email}"
}

# Allow Function SA to use Vertex AI to generate the CV summary using Gemini
resource "google_project_iam_member" "vertex_ai_user" {
  project = var.project_id
  role    = "roles/aiplatform.user"
  member  = "serviceAccount:${google_service_account.function_sa.email}"
}

# Fetch the default Cloud Storage service agent account
data "google_storage_project_service_account" "gcs_account" {}

# Allow the Cloud Storage service agent to publish events to Pub/Sub
# (Eventarc uses Pub/Sub under the hood to route GCS events to Cloud Functions)
resource "google_project_iam_member" "gcs_pubsub_publishing" {
  project = var.project_id
  role    = "roles/pubsub.publisher"
  member  = "serviceAccount:${data.google_storage_project_service_account.gcs_account.email_address}"
}

# ==============================================================================
# 5. CLOUD FUNCTION (2nd Gen) WITH EVENTARC TRIGGER
# ==============================================================================
resource "google_cloudfunctions2_function" "cv_processor_function" {
  name        = "cv-analyzer-function"
  location    = var.region
  description = "Analyzes CVs and creates summaries using Vertex AI"

  build_config {
    runtime     = "python311"
    entry_point = "process_cv" # Matches the function name in main.py
    source {
      storage_source {
        bucket = google_storage_bucket.function_source_bucket.name
        object = google_storage_bucket_object.function_source.name
      }
    }
  }

  service_config {
    max_instance_count    = 5
    min_instance_count    = 0
    available_memory      = "1024M" # Increased memory for PDF and AI processing
    timeout_seconds       = 300
    service_account_email = google_service_account.function_sa.email

    # Pass the output bucket name to the function as an environment variable
    environment_variables = {
      OUTPUT_BUCKET = google_storage_bucket.summary_output_bucket.name
    }
  }

  event_trigger {
    # Trigger on finalized object in the input bucket
    event_type            = "google.cloud.storage.object.v1.finalized"
    trigger_region        = var.region
    service_account_email = google_service_account.function_sa.email

    event_filters {
      attribute = "bucket"
      value     = google_storage_bucket.cv_input_bucket.name
    }
  }

  # Ensure APIs and IAM permissions are in place before deploying the function
  depends_on = [
    google_project_service.enabled_apis,
    google_project_iam_member.gcs_pubsub_publishing,
    google_project_iam_member.eventarc_receiver,
    google_project_iam_member.vertex_ai_user
  ]
}

resource "google_cloud_run_service_iam_member" "eventarc_invoker" {
  project  = var.project_id
  location = var.region
  service  = google_cloudfunctions2_function.cv_processor_function.service_config[0].service
  role     = "roles/run.invoker"
  member   = "serviceAccount:${google_service_account.function_sa.email}"
}

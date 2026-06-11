# CV Processor: Automated PDF Analysis with Vertex AI

This project provides a serverless Infrastructure-as-Code (IaC) solution to automatically analyze CVs (PDFs) uploaded to a Google Cloud Storage bucket. It uses a **Cloud Function (2nd Gen)** triggered by **Eventarc** to process the files using **Vertex AI (Gemini)** and generates a summary report in a separate output bucket.

## Architecture Overview

1.  **Input Bucket:** Users upload PDF CVs here.
2.  **Eventarc Trigger:** Detects the upload and triggers the Cloud Function.
3.  **Cloud Function (Python):** 
    *   Downloads the PDF.
    *   Extracts text content.
    *   Sends text to **Gemini** (Vertex AI) for analysis.
    *   Generates a new summary PDF.
4.  **Output Bucket:** Stores the generated summary PDFs.
5.  **Vertex AI:** Powering the intelligent analysis of the CV content.

## Prerequisites

*   [Terraform](https://developer.hashicorp.com/terraform/downloads) (>= 1.0)
*   [Google Cloud SDK (gcloud CLI)](https://cloud.google.com/sdk/docs/install)
*   A Google Cloud Project with Billing enabled.

## Deployment

### 1. Authenticate with Google Cloud

Ensure you are logged in and have the correct project selected:

```bash
gcloud auth login
gcloud auth application-default login
gcloud config set project YOUR_PROJECT_ID
```

### 2. Configure Variables

You can provide your project ID via a `terraform.tfvars` file or as an environment variable.

Create a `terraform.tfvars` file:

```hcl
project_id = "your-gcp-project-id"
region     = "europe-west3" # Optional: defaults to europe-west3
```

### 3. Initialize and Apply

Run the following commands to deploy the infrastructure:

```bash
terraform init
terraform plan
terraform apply
```

## Usage

1.  Once deployed, find the name of the input bucket in the Terraform output (or via the GCP Console). It will be named like `cv-input-XXXX`.
2.  Upload a PDF CV to this bucket:
    ```bash
    gsutil cp my_cv.pdf gs://cv-input-XXXX/
    ```
3.  Monitor the Cloud Function logs to see the processing.
4.  After a few moments, the summary PDF will appear in the output bucket (`cv-summary-output-XXXX`).

## Project Structure

*   `main.tf`: Defines all GCP resources (Buckets, IAM, Cloud Function, APIs).
*   `src/main.py`: The Cloud Function logic (Python).
*   `src/requirements.txt`: Python dependencies (PyPDF2, fpdf, vertexai).

## Clean Up

To avoid incurring charges, destroy the resources when you are finished:

```bash
terraform destroy
```

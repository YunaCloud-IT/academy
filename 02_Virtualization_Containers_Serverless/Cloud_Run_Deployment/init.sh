#!/bin/bash

# A script to deploy a PRIVATE, AUTHENTICATED Cloud Run service.
# This script is idempotent: it can be run multiple times without causing errors.

# --- Script Best Practices ---
# Exit immediately if a command exits with a non-zero status.
set -euo pipefail

# --- Configuration ---
PROJECT_ID=$(gcloud config get-value project)
REGION="europe-west4" # <--- CHANGE THIS to your preferred region (e.g., "europe-west1")

SERVICE_NAME="hello-world-service-private" # The name for your Cloud Run service
SA_ID="cloud-run-runtime-sa"               # The short name for your custom service account
SA_DISPLAY_NAME="Cloud Run Runtime SA"

# Construct the full email address for the custom service account
SA_EMAIL="${SA_ID}@${PROJECT_ID}.iam.gserviceaccount.com"

echo "--- Script Configuration ---"
echo "Project ID:             ${PROJECT_ID}"
echo "Region:                 ${REGION}"
echo "Cloud Run Service Name: ${SERVICE_NAME}"
echo "Service Account Email:  ${SA_EMAIL}"
echo "--------------------------"
echo

# --- 1. Create the Custom Service Account (if it doesn't exist) ---
echo "STEP 1: Checking for and creating the custom service account..."

if gcloud iam service-accounts describe "${SA_EMAIL}" --project="${PROJECT_ID}" >/dev/null 2>&1; then
  echo "✅ Service account '${SA_EMAIL}' already exists. Skipping creation."
else
  echo "Service account not found. Creating it now..."
  gcloud iam service-accounts create "${SA_ID}" \
    --project="${PROJECT_ID}" \
    --display-name="${SA_DISPLAY_NAME}"
  echo "✅ Successfully created service account: ${SA_EMAIL}"
fi
echo

# --- 2. Grant Permissions to the Service Account (Placeholder) ---
echo "STEP 2: Granting IAM roles (skipped for this example)."
echo

# --- 3. Deploy the Container to Cloud Run ---
# The --no-allow-unauthenticated flag is the default, making the service private.
# Only authenticated users or service accounts with the 'run.invoker' role can access it.
echo "STEP 3: Deploying the container image to Cloud Run as a private service..."
gcloud run deploy "${SERVICE_NAME}" \
  --project="${PROJECT_ID}" \
  --region="${REGION}" \
  --image="gcr.io/cloudrun/hello" \
  --service-account="${SA_EMAIL}" \
  --no-allow-unauthenticated \
  --platform="managed"

echo "✅ Deployment command executed."
echo

# --- 4. Display the Service URL ---
echo "STEP 4: Fetching the service URL..."
SERVICE_URL=$(gcloud run services describe "${SERVICE_NAME}" --project="${PROJECT_ID}" --region="${REGION}" --format="value(status.url)")

echo "--------------------------------------------------------"
echo "🚀 Deployment of PRIVATE service complete!"
echo "Service URL: ${SERVICE_URL}"
echo ""
echo "To invoke this service, you must provide an authenticated identity token."
echo "Example for manual testing:"
echo "curl -H \"Authorization: Bearer \$(gcloud auth print-identity-token)\" ${SERVICE_URL}"
echo "--------------------------------------------------------"

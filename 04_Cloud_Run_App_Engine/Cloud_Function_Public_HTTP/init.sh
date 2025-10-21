#!/bin/bash

# Exit immediately if a command exits with a non-zero status.
set -euo pipefail

# --- Configuration ---
# This script will use your currently configured gcloud project.
# You can verify it by running `gcloud config get-value project`.
PROJECT_ID=$(gcloud config get-value project)
CUSTOM_SA_ID="cloud-function-builder" # The short name for your custom service account
CUSTOM_SA_DISPLAY_NAME="Custom Cloud Function Builder"

# Construct the full email address for the custom service account
CUSTOM_SA_EMAIL="${CUSTOM_SA_ID}@${PROJECT_ID}.iam.gserviceaccount.com"

echo "--- Script Configuration ---"
echo "Project ID: ${PROJECT_ID}"
echo "Custom Service Account: ${CUSTOM_SA_EMAIL}"
echo "--------------------------"
echo

# --- 1. Create the Custom Build Service Account (if it doesn't exist) ---
echo "Step 1: Checking for and creating custom service account..."

# Check if the service account already exists by trying to describe it.
# The output is redirected to /dev/null to keep the script clean.
if gcloud iam service-accounts describe "${CUSTOM_SA_EMAIL}" --project="${PROJECT_ID}" >/dev/null 2>&1; then
  echo "✅ Service account '${CUSTOM_SA_EMAIL}' already exists. Skipping creation."
else
  echo "Service account not found. Creating it now..."
  gcloud iam service-accounts create "${CUSTOM_SA_ID}" \
    --project="${PROJECT_ID}" \
    --display-name="${CUSTOM_SA_DISPLAY_NAME}"
  echo "✅ Successfully created service account: ${CUSTOM_SA_EMAIL}"
fi
echo

# --- 2. Grant Permissions to the Custom Service Account ---
echo "Step 2: Granting necessary IAM roles to the custom service account..."

# Grant permissions required for a build service to deploy Cloud Functions (2nd Gen)
# - roles/run.admin: Allows creating and managing Cloud Run services (which 2nd Gen functions are).
# - roles/iam.serviceAccountUser: Allows the build service to act as/attach other service accounts to the function at runtime.
gcloud projects add-iam-policy-binding "${PROJECT_ID}" \
 --member="serviceAccount:${CUSTOM_SA_EMAIL}" \
 --role="roles/run.admin"

gcloud projects add-iam-policy-binding "${PROJECT_ID}" \
 --member="serviceAccount:${CUSTOM_SA_EMAIL}" \
 --role="roles/iam.serviceAccountUser"

echo "✅ Successfully granted 'Cloud Run Admin' and 'Service Account User' roles."
echo

# --- 3. Enable the Default Compute Engine Service Account ---
echo "Step 3: Enabling the default Compute Engine service account..."

# Get your project number, which is required to construct the default SA's email
PROJECT_NUMBER=$(gcloud projects describe "${PROJECT_ID}" --format='value(projectNumber)')

# Construct the default compute SA email
DEFAULT_COMPUTE_SA="${PROJECT_NUMBER}-compute@developer.gserviceaccount.com"

# Enable the service account
gcloud iam service-accounts enable "${DEFAULT_COMPUTE_SA}" \
  --project="${PROJECT_ID}"

echo "✅ Successfully enabled default compute service account: ${DEFAULT_COMPUTE_SA}"
echo

echo "--- All steps completed successfully! ---"

echo
echo "✅ Use this service account for your cloud function: ${CUSTOM_SA_EMAIL}"

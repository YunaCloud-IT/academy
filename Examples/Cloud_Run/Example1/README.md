
# Deploying the Hello World Container to Google Cloud Run

This guide explains how to deploy the official `gcr.io/cloudrun/hello` container image to a fully managed Google Cloud Run service using the `gcloud` command-line tool.

## Prerequisites

Before running the deployment command, ensure you have the following:

1.  **Google Cloud SDK installed:** Verify with `gcloud --version`.
2.  **Authenticated session:** Run `gcloud auth login`.
3.  **Active Project:** Ensure you have a project selected.
    ```bash
    gcloud config set project [YOUR_PROJECT_ID]
    ```
4.  **Cloud Run API Enabled:**
    ```bash
    gcloud services enable run.googleapis.com
    ```

## Deployment Command

Run the following command in your terminal to deploy the service.

```bash
gcloud run deploy hello-world \
  --image=gcr.io/cloudrun/hello \
  --allow-unauthenticated \
  --region=us-central1 \
  --platform=managed
```

## Flag Breakdown

- `hello-world`: The name you are assigning to your Cloud Run service.

- `--image`: The source URL of the container image (in this case, Google's public hello image).

- `--allow-unauthenticated`: Makes the service publicly accessible via the internet. (Omit this flag if you want the service to be private/internal only).

- `--region`: The Google Cloud data center location (e.g., us-central1, europe-west1).

- `--platform=managed`: Specifies that you want to deploy to the fully managed Cloud Run platform.

## Verification

Once the command finishes, it will output a Service URL.

1. Copy the URL provided in the output (e.g., `https://hello-world-xyz123-uc.a.run.app`).

2. Open it in your browser or test it with `curl`:

```bash
curl https://[YOUR-SERVICE-URL].run.app
```

You should see the "It's running!" success page with the Cloud Run logo.

## Cleanup

To remove the service and stop billing for it, run:

```bash
gcloud run services delete hello-world --region=us-central1
```

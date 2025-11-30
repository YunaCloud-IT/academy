# Build and Deploy Go App to Google Cloud Run

This guide assumes you have `main.go`, `go.mod`, and `Dockerfile` in your current directory.

## Prerequisites

Ensure your environment is set up:

### Login to Google Cloud:

```bash
gcloud auth login
```

### Set your Project ID:

```bash
gcloud config set project [YOUR_PROJECT_ID]
```

### Enable Required APIs:

```bash
gcloud services enable run.googleapis.com \
artifactregistry.googleapis.com \
cloudbuild.googleapis.com
```

## Option 1: The "One-Command" Deploy (Recommended)

Google Cloud Run can build your Dockerfile and deploy it in a single step. This is the fastest way to get started.

Run this command in the folder containing your files:

```bash
gcloud run deploy go-hello-world \
--source . \
--region us-central1 \
--allow-unauthenticated
```

- `--source .`: Uploads the current directory and builds it using the `Dockerfile` found inside.

- `--allow-unauthenticated`: Makes the URL public. Remove this flag for private services.

## Option 2: The "Build then Deploy" Method

Use this method if you want to push the image to the registry first and deploy it later (or deploy it to multiple services).

### Step 1: Create an Artifact Registry Repository

Create a Docker repository to store your images (you only do this once).

```bash
gcloud artifacts repositories create my-repo \
--repository-format=docker \
--location=us-central1 \
--description="My Go App Repository"
```

### Step 2: Build and Push the Image

Submit your code to Cloud Build. It will use your `Dockerfile` to create the image and store it in the repository.

```bash
gcloud builds submit --tag us-central1-docker.pkg.dev/$(gcloud config get-value project)/my-repo/go-hello-world:v1
```

### Step 3: Deploy the Image

Now deploy that specific image to Cloud Run.

```bash
gcloud run deploy go-hello-world \
--image us-central1-docker.pkg.dev/$(gcloud config get-value project)/my-repo/go-hello-world:v1 \
--region us-central1 \
--allow-unauthenticated
```

## Verification

After deployment, the terminal will display a Service URL (e.g., `https://go-hello-world-xyz123-uc.a.run.app`).

### Test via cURL:

```bash
curl https://[YOUR-SERVICE-URL]
```

### Check Logs:

To see the `log.Println` messages we added earlier:

```bash
gcloud logging read "resource.type=cloud_run_revision AND resource.labels.service_name=go-hello-world" --limit 10
```

## Cleanup

To delete the service and stop billing:

```bash
gcloud run services delete go-hello-world --region us-central1
```

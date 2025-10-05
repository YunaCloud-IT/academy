# Guide: Deploying a Custom NGINX Web App to Cloud Run

This guide provides an end-to-end walkthrough for deploying a custom web application. You will create a simple HTML page, containerize it with NGINX and a Dockerfile, build the container image using Cloud Build, store it in Artifact Registry, and finally deploy it as a public service on Cloud Run.

## Prerequisites

* **Google Cloud Project:** An active project with billing enabled.
* **gcloud CLI:** The [Google Cloud CLI](https://cloud.google.com/sdk/docs/install) installed and authenticated.
* **Docker:** While Cloud Build executes the build remotely, having [Docker installed locally](https://docs.docker.com/engine/install/) is recommended for container development.

---

### Step 1: Create the Web Application Locally

First, set up the directory structure and files for your simple NGINX-powered website.

1.  **Create the project directories and files:**
    Open your terminal and run the following commands to create the necessary folders and files.

    ```bash
    # Create the main project directory
    mkdir cloudrun-webapp
    cd cloudrun-webapp

    # Create subdirectories for HTML and NGINX config
    mkdir -p html nginx

    # Create the index.html file
    cat > html/index.html <<EOF
    <html>
    <head>
        <title>Welcome to Cloud Run</title>
        <style>
            body { font-family: sans-serif; text-align: center; padding-top: 5em; }
        </style>
    </head>
    <body>
        <h1>Success! Your NGINX container is running on Google Cloud Run.</h1>
    </body>
    </html>
    EOF

    # Create the NGINX configuration file
    cat > nginx/default.conf <<EOF
    server {
        listen      8080;
        server_name localhost;
        
        location / {
            root    /usr/share/nginx/html;
            index   index.html;
        }
    }
    EOF

    # Create the Dockerfile
    cat > Dockerfile <<EOF
    # Use the official NGINX image as a base
    FROM nginx:latest

    # Copy the static website content
    COPY html /usr/share/nginx/html

    # Copy the custom NGINX configuration
    COPY nginx/default.conf /etc/nginx/conf.d/default.conf
    EOF
    ```

2.  **Verify the directory structure:**
    Your `cloudrun-webapp` directory should now look like this:
    ```
    .
    ├── Dockerfile
    ├── html
    │   └── index.html
    └── nginx
        └── default.conf
    ```

---

### Step 2: Configure Your Google Cloud Environment

Before building, prepare your cloud environment by setting variables, enabling APIs, and creating a repository for your container image.

1.  **Set environment variables:**
    Using variables makes the following commands much cleaner. Given your location in Brandenburg, Germany, `europe-west3` (Frankfurt) is a suitable region.

    ```bash
    export PROJECT_ID=$(gcloud config get-value project)
    export REGION="europe-west3"
    export REPO_NAME="my-web-apps"
    export IMAGE_NAME="nginx-web"
    export SERVICE_NAME="my-nginx-webapp"
    ```

2.  **Enable necessary APIs:**
    ```bash
    gcloud services enable \
      run.googleapis.com \
      cloudbuild.googleapis.com \
      artifactregistry.googleapis.com
    ```

3.  **Create an Artifact Registry repository:**
    This is a one-time setup to create a place to store your Docker images.
    ```bash
    gcloud artifacts repositories create $REPO_NAME \
      --repository-format=docker \
      --location=$REGION \
      --description="Repository for web app containers"
    ```

---

### Step 3: Build and Push the Container Image

Use Cloud Build to build your Docker image and push it to the Artifact Registry repository you just created.

1.  **Start the build process:**
    Run this command from the root of your `cloudrun-webapp` directory.

    ```bash
    gcloud builds submit . \
      --tag="${REGION}-docker.pkg.dev/${PROJECT_ID}/${REPO_NAME}/${IMAGE_NAME}:latest"
    ```
    Cloud Build will zip your local files, upload them, execute the build based on your `Dockerfile`, and push the resulting image to Artifact Registry.

---

### Step 4: Deploy the Container to Cloud Run

Deploy the container image you just built to a new, publicly accessible Cloud Run service.

1.  **Run the deployment command:**
    ```bash
    gcloud run deploy $SERVICE_NAME \
      --image="${REGION}-docker.pkg.dev/${PROJECT_ID}/${REPO_NAME}/${IMAGE_NAME}:latest" \
      --platform="managed" \
      --region=$REGION \
      --allow-unauthenticated
    ```
    * **`$SERVICE_NAME`**: Explicitly names your service.
    * **`--allow-unauthenticated`**: This flag makes the service public and automatically configures the correct IAM permissions. This replaces the need for manual IAM binding commands.

---

### Step 5: Verify Your Deployment

Once the deployment completes, the `gcloud` CLI will output the public URL for your service.

1.  **Find and open the URL:**
    Look for the Service URL in the command's output.
2.  **Open the URL** in your web browser. You should see your message: "Success! Your NGINX container is running on Google Cloud Run."

---

### Step 6: Cleanup

To avoid incurring costs for resources you are no longer using, perform the following cleanup steps.

1.  **Delete the Cloud Run service:**
    ```bash
    gcloud run services delete $SERVICE_NAME --platform=managed --region=$REGION --quiet
    ```

2.  **Delete the container image from Artifact Registry:**
    ```bash
    gcloud artifacts docker images delete \
      "${REGION}-docker.pkg.dev/${PROJECT_ID}/${REPO_NAME}/${IMAGE_NAME}:latest" --quiet
    ```
    *(Note: Deleting the repository itself requires deleting all images within it first.)*

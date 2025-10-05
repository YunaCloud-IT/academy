# Guide: Deploying a Prebuilt Container to Cloud Run

This guide will walk you through deploying a prebuilt "Hello World" container image to a **private** Google Cloud Run service. You will then learn how to securely access it using an identity token from the `gcloud` CLI.

## Prerequisites

Before you start, ensure you have the following ready:

1.  **Google Cloud Project:** A project with an active billing account.
2.  **gcloud CLI:** The [Google Cloud CLI](https://cloud.google.com/sdk/docs/install) installed and configured on your local machine.

---

### Step 1: Environment Setup and Configuration

First, prepare your local terminal by authenticating and configuring your project.

1.  **Log in to your Google Account:**
    ```bash
    gcloud auth login
    ```
    This command will open a browser window for you to complete the authentication process.

2.  **Set your Google Cloud Project:**
    ```bash
    # Replace "[YOUR_PROJECT_ID]" with your actual Project ID
    gcloud config set project [YOUR_PROJECT_ID]
    ```

3.  **Enable the Cloud Run API:**
    If it's your first time using Cloud Run in this project, you need to enable the necessary API.
    ```bash
    gcloud services enable run.googleapis.com
    ```

---

### Step 2: Deploy the Private Cloud Run Service

Now, you will deploy a sample container from Google's Artifact Registry. By default, Cloud Run services are private and require authentication, which is the secure configuration we will use.

1.  **Define environment variables for your service:**
    Using variables makes the commands cleaner and easier to reuse. Since the current location is Brandenburg, we'll use a nearby region.
    ```bash
    export SERVICE_NAME="hello-world-private"
    export REGION="europe-west3" # Frankfurt
    ```

2.  **Deploy the prebuilt container:**
    This command pulls the public "hello" container and deploys it as a new, private service in your project.
    ```bash
    gcloud run deploy $SERVICE_NAME \
      --image="us-docker.pkg.dev/cloudrun/container/hello" \
      --platform="managed" \
      --region=$REGION \
      --no-allow-unauthenticated
    ```
    * **`--image`**: Specifies the prebuilt container image to use.
    * **`--no-allow-unauthenticated`**: This is the key flag that makes your service private. Only authenticated users or service accounts with the correct IAM permissions (`roles/run.invoker`) can access it.

3.  **Get the URL of your new service:**
    After a successful deployment, retrieve the service URL and store it in a variable for the next step.
    ```bash
    export SERVICE_URL=$(gcloud run services describe $SERVICE_NAME --platform=managed --region=$REGION --format="value(status.url)")
    echo "Service deployed to URL: $SERVICE_URL"
    ```

---

### Step 3: Securely Access the Service

Because the service is private, you cannot simply open the URL in a browser. You must provide a valid identity token with your request to prove you have permission to invoke it.

1.  **Invoke the service using `curl` and an identity token:**
    The following command fetches a short-lived identity token for your logged-in user and includes it in the request header.
    ```bash
    curl -H "Authorization: Bearer $(gcloud auth print-identity-token)" $SERVICE_URL
    ```

    If successful, the service will respond with: `Congratulations, you successfully deployed a container image to Cloud Run!`

---

### Step 4: Cleanup

To avoid incurring ongoing costs, always delete resources you are no longer using.

1.  **Delete the Cloud Run service:**
    ```bash
    gcloud run services delete $SERVICE_NAME --platform=managed --region=$REGION
    ```
    You will be prompted to confirm the deletion. Type `Y` to proceed.

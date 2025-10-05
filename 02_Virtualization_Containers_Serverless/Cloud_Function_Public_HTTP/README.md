# Guide: Deploying a Public Node.js HTTP Cloud Function (2nd Gen)

This guide provides a complete walkthrough for creating and deploying a simple, publicly accessible "Hello World" HTTP Cloud Function using Node.js and the `gcloud` command-line tool.

## Prerequisites

Before you begin, ensure you have the following:

1.  **Google Cloud Project:** A project with billing enabled.
2.  **gcloud CLI:** The [Google Cloud CLI](https://cloud.google.com/sdk/docs/install) installed and initialized.
3.  **Node.js:** A recent LTS version of [Node.js](https://nodejs.org/) installed on your local machine.

---

### Step 1: Configure Your Local Environment

First, authenticate your `gcloud` CLI and set your target project.

1.  **Log in to Google Cloud:**
    ```bash
    gcloud auth login
    ```
    Follow the prompts in your browser to authorize the CLI.

2.  **Set your Project ID:**
    ```bash
    # Replace "[YOUR_PROJECT_ID]" with your actual Google Cloud Project ID
    gcloud config set project [YOUR_PROJECT_ID]
    ```

3.  **Enable Required APIs:** Cloud Functions depend on several other services. Enable them now to prevent errors during deployment.
    ```bash
    gcloud services enable \
      cloudfunctions.googleapis.com \
      cloudbuild.googleapis.com \
      run.googleapis.com \
      logging.googleapis.com \
      iam.googleapis.com
    ```

---

### Step 2: Create a Dedicated Service Account

For better security, your function should run with its own identity that has minimal permissions.

1.  **Create the Service Account:**
    ```bash
    # You can change "my-function-sa" to a name of your choice
    gcloud iam service-accounts create my-function-sa \
      --display-name="My HTTP Function Service Account"
    ```

2.  **Get the full email address of the new service account:**
    You will need this for the deployment step.
    ```bash
    # Replace "[YOUR_PROJECT_ID]" with your Project ID
    export SA_EMAIL="my-function-sa@[YOUR_PROJECT_ID].iam.gserviceaccount.com"
    echo "Service Account Email: $SA_EMAIL"
    ```

---

### Step 3: Write the Function Code

Now, create the Node.js project and the function's source code.

1.  **Create a project folder:**
    ```bash
    mkdir cloud-function-code
    cd cloud-function-code
    ```

2.  **Initialize a Node.js project:**
    ```bash
    npm init -y
    ```
    The `-y` flag accepts all the default settings.

3.  **Create an `index.js` file:**
    In the `cloud-function-code` directory, create a file named `index.js`.

4.  **Add the function code:**
    Copy and paste the following JavaScript code into your `index.js` file. This is a simple HTTP function that responds with "Hello World!".

    ```javascript
    /**
     * A simple public HTTP Cloud Function.
     *
     * @param {Object} req The HTTP request object.
     * @param {Object} res The HTTP response object.
     */
    exports.helloHttp = (req, res) => {
      res.status(200).send("Hello World!");
    };
    ```

---

### Step 4: Deploy the Cloud Function

With the code and configuration complete, you can now deploy the function.

1.  **Run the deployment command from your project folder (`cloud-function-code`):**

    This command deploys a 2nd Generation HTTP-triggered function that allows public (unauthenticated) access.

    ```bash
    gcloud functions deploy hello-http-function \
      --gen2 \
      --runtime nodejs20 \
      --region europe-west3 \
      --source . \
      --entry-point helloHttp \
      --trigger-http \
      --allow-unauthenticated \
      --service-account=$SA_EMAIL
    ```
    * **`--gen2`**: Specifies a 2nd Generation function, which is built on Cloud Run and offers better performance and features.
    * **`--runtime nodejs20`**: Sets the Node.js runtime. Use a current LTS version.
    * **`--region`**: Deploys the function to a specific region (e.g., `europe-west3` for Frankfurt).
    * **`--allow-unauthenticated`**: This is the key flag that makes the function public.
    * **`--service-account`**: Attaches the dedicated service account you created.

---

### Step 5: Test Your Function

Once the deployment is complete, the `gcloud` CLI will output a trigger URL.

1.  **Find the Trigger URL:**
    Look for the `uri:` field in the command's output. It will look like this:
    `uri: https://hello-http-function-xxxxxxxx-xx.a.run.app`

2.  **Test the URL:**
    Click the URL or copy and paste it into your browser. You should see the message "Hello World!".

    *Alternatively, you can find the URL in the Google Cloud Console by navigating to **Cloud Functions**, clicking on your `hello-http-function`, and going to the **TRIGGER** tab.*

---

### Step 6: Cleanup

To avoid incurring future costs, delete the resources you created.

1.  **Delete the Cloud Function:**
    ```bash
    gcloud functions delete hello-http-function --gen2 --region europe-west3
    ```
    Enter `y` when prompted to confirm.

2.  **Delete the Service Account:**
    ```bash
    gcloud iam service-accounts delete $SA_EMAIL
    ```
    Enter `y` when prompted to confirm.

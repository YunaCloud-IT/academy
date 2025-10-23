# Uploading a File to Google Cloud Storage with Node.js

This guide demonstrates how to programmatically upload a file to a Google Cloud Storage (GCS) bucket using the official Google Cloud client library for Node.js, without relying on the `gsutil` command-line tool.

---

## 📝 Prerequisites

Before you begin, ensure you have the following set up:

1.  **Node.js:** You need Node.js installed on your machine. You can download it from [nodejs.org](https://nodejs.org/).
2.  **Google Cloud Project:** A Google Cloud Platform (GCP) project with the Cloud Storage API enabled.
3.  **GCS Bucket:** A bucket created in your GCP project where the file will be uploaded.
4.  **Service Account:** A service account with the **Storage Object Admin** (`roles/storage.objectAdmin`) role is required to grant your script permission to write objects to the bucket.
5.  **Service Account Key:** Download the JSON key file for your service account. **Treat this file securely**, as it grants access to your cloud resources.
6.  **Node.js Client Library:** Install the official GCS client library using npm:
    ```bash
    npm install @google-cloud/storage
    ```

---

## 💻 Node.js Code Example

This script, named `upload.js`, uploads a local file (`local-file.txt`) to your specified GCS bucket.

```javascript
// Import the Google Cloud Storage client library
const { Storage } = require('@google-cloud/storage');

// For this example, we'll create a new Storage client.
// By default, the library will look for the service account key file
// via the GOOGLE_APPLICATION_CREDENTIALS environment variable.
const storage = new Storage();

/**
 * Uploads a local file to a GCS bucket.
 *
 * @param {string} bucketName The name of your GCS bucket. E.g., 'my-unique-bucket'
 * @param {string} filePath The path to your local file. E.g., './local-file.txt'
 * @param {string} destFileName The name of the file in the bucket. E.g., 'uploaded-file.txt'
 */
async function uploadFile(bucketName, filePath, destFileName) {
  try {
    const options = {
      destination: destFileName,
      // Optional: set metadata.
      metadata: {
        cacheControl: 'public, max-age=31536000',
      },
    };

    // The upload() method will upload a local file to the bucket.
    await storage.bucket(bucketName).upload(filePath, options);
    console.log(`✅ Successfully uploaded ${filePath} to ${bucketName} as ${destFileName}.`);
  } catch (e) {
    console.error(`❌ Failed to upload file. Error: ${e.message}`);
  }
}

// --- Main execution ---
// Ensure you have a file named 'local-file.txt' in the same directory
// or update the path accordingly.
const bucketName = 'your-unique-bucket-name'; // ⚠️ **Replace this with your bucket name**
const filePath = './local-file.txt';
const destFileName = 'my-uploaded-file.txt';

// Run the upload function
uploadFile(bucketName, filePath, destFileName).catch(console.error);
```

## ▶️ How to Run the Script

1. Create a Sample File: Create a file named `local-file.txt` in the same directory as your `upload.js` script and add some text to it.

2. Set Authentication Credentials: Set an environment variable to point to your service account key file. This allows the client library to authenticate automatically.

- macOS / Linux:

```
export GOOGLE_APPLICATION_CREDENTIALS="/path/to/your/keyfile.json"
```

- Windows (PowerShell):

```
$env:GOOGLE_APPLICATION_CREDENTIALS="/path/to/your/keyfile.json"
```

3. Execute the Script: Run the Node.js script from your terminal.

```
node upload.js
```

If successful, you will see the confirmation message in your console, and the file my-uploaded-file.txt will appear in your GCS bucket.

```
✅ Successfully uploaded ./local-file.txt to your-unique-bucket-name as my-uploaded-file.txt.
```

---

# How to Generate a Google Cloud Service Account Key File (keyfile.json)

A service account key file is a JSON file that contains private credentials used to authenticate as a service account in your Google Cloud project. This allows applications and scripts running outside of Google Cloud (like on your local machine or an on-premises server) to securely access Google Cloud services.

**⚠️ Important:** This key file grants significant access to your Google Cloud resources. **Treat it like a password** and keep it secure. Never commit it to a public version control repository.

---

## 📋 Prerequisites

Before you start, you'll need:

1.  A **Google Cloud Project**.
2.  Permissions to manage service accounts and create keys. The **Service Account Key Admin** (`roles/iam.serviceAccountKeyAdmin`) role is typically required.

---

## ⚙️ Step-by-Step Guide

Follow these steps to create and download your JSON key file.

1.  **Navigate to the Service Accounts Page**
    * Open the Google Cloud Console: [console.cloud.google.com](https://console.cloud.google.com).
    * In the navigation menu (☰), go to **IAM & Admin** > **Service Accounts**.

2.  **Select Your Project**
    * Using the project selector at the top of the page, choose the project for which you want to create a service account key.

3.  **Choose a Service Account**
    * You'll see a list of service accounts in your project.
    * **If you have an existing service account:** Find it in the list and click on its email address.
    * **If you need a new one:** Click **+ CREATE SERVICE ACCOUNT** at the top, give it a name and description, grant it the necessary IAM roles (e.g., "Storage Admin" for Cloud Storage access), and click **DONE**. Then, click on the email address of the new service account you just created.

4.  **Go to the Keys Tab**
    * Inside the service account's details page, click on the **KEYS** tab.

5.  **Create a New Key**
    * Click the **ADD KEY** button and select **Create new key** from the dropdown menu.
    * A dialog box will appear.

6.  **Select Key Type and Download**
    * Choose **JSON** as the key type. This is the recommended format for most use cases.
    * Click the **CREATE** button.
    * Your browser will automatically download the JSON key file. It's often named something like `project-name-12345-abcdef123456.json`. You can rename this file to `keyfile.json` for convenience if you wish.

You have now successfully generated and downloaded your service account key file!

---

## 🔒 Security Best Practices

* **Do Not Commit to Git:** Add the filename (`keyfile.json` or similar) to your `.gitignore` file to prevent it from ever being checked into version control.
* **Use Environment Variables:** The standard and most secure way to use this key in your application is to set the `GOOGLE_APPLICATION_CREDENTIALS` environment variable to the path of the key file. The Google Cloud client libraries will automatically find and use it for authentication.
    * **Example (Linux/macOS):**
        ```bash
        export GOOGLE_APPLICATION_CREDENTIALS="/path/to/your/keyfile.json"
        ```
    * **Example (Windows PowerShell):**
        ```powershell
        $env:GOOGLE_APPLICATION_CREDENTIALS="C:\path\to\your\keyfile.json"
        ```
* **Limit Permissions:** Grant your service account only the roles and permissions it absolutely needs to perform its function (principle of least privilege).

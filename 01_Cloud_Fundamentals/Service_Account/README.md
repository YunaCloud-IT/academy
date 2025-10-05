# How to Create a Service Account for Compute Engine

This guide provides a step-by-step walkthrough for creating a Google Cloud service account, granting it an appropriate Identity and Access Management (IAM) role, and attaching it to a Compute Engine virtual machine (VM).

A **service account** is a special type of non-human identity that an application or a VM can use to authenticate and make authorized API calls to Google Cloud services. Attaching a service account to a VM is the secure, recommended way to grant it permissions without embedding secret keys in your code.

## Prerequisites

* A Google Cloud project with billing enabled.
* Permissions to manage IAM and service accounts in your project (e.g., having the `Project IAM Admin` and `Service Account Admin` roles).
* The [Google Cloud SDK](https://cloud.google.com/sdk/docs/install) (`gcloud` CLI) installed and configured (for the CLI methods).

---

## Step 1: Create the Service Account

First, you need to create the service account identity itself.

### Method A: Using the Google Cloud Console

1.  In the Google Cloud Console, navigate to **IAM & Admin** > **Service Accounts**.
    * [Go to Service Accounts](https://console.cloud.google.com/iam-admin/serviceaccounts)
2.  Click **+ CREATE SERVICE ACCOUNT**.
3.  Enter the following details:
    * **Service account name:** A user-friendly name, e.g., `my-compute-engine-sa`.
    * **Service account ID:** This will be auto-generated based on the name. Note this ID.
    * **Description:** A clear description of its purpose, e.g., "Service account for the primary application VM".
4.  Click **CREATE AND CONTINUE**.
5.  In the **Grant this service account access to project** step, you can assign roles. For clarity, we will do this in the next section. For now, click **CONTINUE**.
6.  Click **DONE** to finish creating the account.

### Method B: Using the `gcloud` CLI

1.  Open your terminal or Cloud Shell.
2.  Run the following command, replacing the placeholder values:
    ```bash
    gcloud iam service-accounts create your-sa-id \
        --display-name="My Compute Engine SA" \
        --description="Service account for the primary application VM"
    ```
    * `your-sa-id`: A unique ID for the service account (e.g., `my-compute-engine-sa`).

---

## Step 2: Grant IAM Roles to the Service Account

Now, give the service account the permissions it needs to perform tasks. We follow the principle of least privilege by granting only the necessary roles.

For this example, we'll grant the `Compute Instance Admin (v1)` role, which allows the service account to manage VM instances.

### Method A: Using the Google Cloud Console

1.  Navigate to the main **IAM** page in the Cloud Console.
    * [Go to IAM](https://console.cloud.google.com/iam-admin/iam)
2.  Click **+ GRANT ACCESS**.
3.  In the **New principals** field, start typing the name of the service account you created (e.g., `my-compute-engine-sa`) and select it.
4.  In the **Assign roles** section, click the **Select a role** dropdown.
5.  Search for and select the `Compute Instance Admin (v1)` role.
6.  Click **SAVE**.

### Method B: Using the `gcloud` CLI

1.  To grant the role, you need the full email address of the service account and your project ID. The service account email follows the format: `your-sa-id@your-project-id.iam.gserviceaccount.com`.
2.  Run the `add-iam-policy-binding` command:
    ```bash
    gcloud projects add-iam-policy-binding your-project-id \
        --member="serviceAccount:your-sa-id@your-project-id.iam.gserviceaccount.com" \
        --role="roles/compute.instanceAdmin.v1"
    ```
    * Replace `your-project-id` and `your-sa-id` with your actual values.

---

## Step 3: Attach the Service Account to a VM

A service account only works for a VM when it is attached. You can do this when creating a new VM or by editing an existing one (the VM must be stopped to change its service account).

### Method A: Using the Google Cloud Console (During VM Creation)

1.  When creating a new Compute Engine VM, go to the **Identity and API access** section.
2.  In the **Service account** dropdown, select the service account you created (e.g., `my-compute-engine-sa`).
3.  Finish configuring your VM and click **Create**.

### Method B: Using the `gcloud` CLI (During VM Creation)

1.  Use the `--service-account` flag when creating your instance.
    ```bash
    gcloud compute instances create my-vm-instance \
        --project=your-project-id \
        --zone=us-central1-a \
        --machine-type=e2-medium \
        --image-family=debian-11 \
        --image-project=debian-cloud \
        --service-account=your-sa-id@your-project-id.iam.gserviceaccount.com
    ```

---

## Step 4: Verify the Configuration

1.  SSH into the VM instance you created.
    ```bash
    gcloud compute ssh my-vm-instance --zone=us-central1-a
    ```
2.  Inside the VM, check the active authenticated account. The metadata server automatically provides credentials for the attached service account to `gcloud` and client libraries.
    ```bash
    gcloud auth list
    ```
    You should see your service account listed as the active account.

3.  Test the permissions. Since we assigned the `Compute Instance Admin` role, this command should succeed.
    ```bash
    # This command should successfully list VM instances in the project
    gcloud compute instances list
    ```
This confirms that your VM is correctly authenticated as the service account and has the permissions you granted.

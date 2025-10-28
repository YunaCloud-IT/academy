# How to Add IAM Roles to a Google Cloud Service Account

This guide demonstrates how to grant permissions to a service account in Google Cloud by assigning it IAM (Identity and Access Management) roles. A service account needs permissions to access Google Cloud resources, just like a regular user. This is done by granting it specific roles.

---

## Prerequisites

Before you start, make sure you have the following:

* **Project ID**: The ID of the Google Cloud project where the service account and resources reside.
* **Service Account Email**: The full email address of the service account (e.g., `my-sa@your-project-id.iam.gserviceaccount.com`).
* **Required Permissions**: You must have permissions to manage IAM policies, such as the **Project IAM Admin** (`roles/resourcemanager.projectIamAdmin`) role.

---

## Method 1: Using the Google Cloud Console (GUI)

The Cloud Console provides a user-friendly interface for managing IAM roles.

1.  **Navigate to IAM**: Open the [IAM & Admin page](https://console.cloud.google.com/iam-admin/iam) in the Google Cloud Console.

2.  **Grant Access**: Click the **<font size="2">➕</font> GRANT ACCESS** button at the top of the page.


3.  **Add Principal**: In the **New principals** field, paste the full email address of your service account.

4.  **Assign Role**: In the **Assign roles** dropdown, search for and select the role you want to grant. For this example, we'll add the **Storage Object Viewer** (`roles/storage.objectViewer`) role, which allows read-only access to GCS objects.


5.  **Save**: Click **SAVE**. The service account now has the assigned role for the project.

---

## Method 2: Using the `gcloud` Command-Line Tool (CLI)

For automation and scripting, the `gcloud` CLI is the recommended method. The command adds a new role binding to the project's IAM policy.

The basic syntax is:
```sh
gcloud projects add-iam-policy-binding PROJECT_ID --member='serviceAccount:SERVICE_ACCOUNT_EMAIL' --role='ROLE_ID'
```

### Example

Let's grant the **Storage Object Viewer** (`roles/storage.objectViewer`) role to a service account.

1.  **Set your variables** (optional, but recommended for clarity):
    ```bash
    PROJECT_ID="your-gcp-project-id"
    SA_EMAIL="my-service-account@your-gcp-project-id.iam.gserviceaccount.com"
    ROLE_ID="roles/storage.objectViewer"
    ```

2.  **Run the command**:
    ```bash
    gcloud projects add-iam-policy-binding $PROJECT_ID \
        --member="serviceAccount:$SA_EMAIL" \
        --role=$ROLE_ID
    ```

After running the command, you will see an `updated IAM policy` message confirming the change.

---

## Verifying Permissions

You can verify that the role was successfully added.

* **Via Cloud Console**: Go to the **IAM** page, find the service account email in the principals list, and check the roles assigned to it in the "Role" column.
* **Via `gcloud` CLI**:
    ```bash
    # Replace with your project ID and service account email
    gcloud projects get-iam-policy your-gcp-project-id \
      --flatten="bindings[].members" \
      --filter="bindings.members:my-service-account@your-gcp-project-id.iam.gserviceaccount.com" \
      --format="table(bindings.role)"
    ```
  This command filters the IAM policy to show only the roles assigned to your specific service account.

---

## Best Practices ✨

* **Principle of Least Privilege**: Always grant the most restrictive roles necessary for the service account to perform its function. Avoid highly permissive roles like `roles/editor` or `roles/owner` unless absolutely required.
* **Custom Roles**: If predefined roles are too broad, create a [custom IAM role](https://cloud.google.com/iam/docs/creating-custom-roles) with a specific set of permissions.
* **Resource-Level Permissions**: When possible, grant roles on a specific resource (e.g., a single Cloud Storage bucket) instead of the entire project to further limit access.

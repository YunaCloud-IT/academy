# How to Create Folders and Projects in Google Cloud Platform

Folders and Projects are the fundamental building blocks for organizing resources in Google Cloud. Folders group projects, and projects contain your actual resources like VMs, databases, and storage buckets. This guide will walk you through creating both.

## Part 1: Creating a Folder

Folders are used to group projects and other folders, allowing you to manage resources hierarchically.

### Prerequisites for Creating Folders

1.  **An Organization resource:** Folders can only be created within an organization. This typically requires a Google Workspace (formerly G Suite) or Cloud Identity account.
2.  **Appropriate IAM Permissions:** You must have the `resourcemanager.folders.create` permission, which is included in the `Folder Creator` (`roles/resourcemanager.folderCreator`) IAM role.

### Creating a Folder using the Google Cloud Console

1.  **Navigate to the Manage Resources page:**
    * Open the [Google Cloud Console](https://console.cloud.google.com/).
    * In the project selector dropdown at the top, select your organization.
    * Click on **"Go to Manage resources"**.

2.  **Create the folder:**
    * On the "Manage resources" page, click **"CREATE FOLDER"** at the top.
    * In the "Folder name" field, enter a descriptive name.
    * For "Location," click "Browse" and select the organization or another folder where you want to create the new folder.
    * Click **"CREATE"**.

### Creating a Folder using the `gcloud` Command-Line Tool

1.  **Authenticate and configure `gcloud`:**
    * Ensure you have the [Google Cloud SDK](https://cloud.google.com/sdk/docs/install) installed and initialized.
    * Authenticate by running: `gcloud auth login`

2.  **Create the folder:**
    * To create a folder directly under your organization:
        ```bash
        gcloud resource-manager folders create \
            --display-name="My New Folder" \
            --organization="[YOUR_ORGANIZATION_ID]"
        ```
      Replace `[YOUR_ORGANIZATION_ID]` with your organization's numeric ID.

    * To create a folder within another folder:
        ```bash
        gcloud resource-manager folders create \
            --display-name="My Nested Folder" \
            --folder="[PARENT_FOLDER_ID]"
        ```
      Replace `[PARENT_FOLDER_ID]` with the numeric ID of the parent folder.

---

## Part 2: Creating a Project

Projects are the core organizational unit where you create, enable, and use Google Cloud services.

### Prerequisites for Creating Projects

1.  **Appropriate IAM Permissions:** You need the `resourcemanager.projects.create` permission, which is part of the `Project Creator` (`roles/resourcemanager.projectCreator`) IAM role. You must have this role on the parent resource (the Organization or Folder where the project will live).
2.  **A Billing Account:** To use most Google Cloud services, your project must be linked to an active billing account.

### Creating a Project using the Google Cloud Console

1.  **Navigate to the Manage Resources page:**
    * Follow the same steps as for creating a folder to get to the "Manage Resources" page.

2.  **Create the project:**
    * On the "Manage resources" page, click **"CREATE PROJECT"**.
    * Enter a **Project name**.
    * Google Cloud automatically generates a unique **Project ID**. You can edit this, but it must be globally unique and cannot be changed later.
    * Select a **Billing account** if prompted.
    * For **Location**, click "Browse" and select your Organization or the Folder where you want this project to reside.
    * Click **"CREATE"**.

### Creating a Project using the `gcloud` Command-Line Tool

1.  **Create the project:**
    * The basic command requires a globally unique Project ID.
        ```bash
        gcloud projects create [YOUR_UNIQUE_PROJECT_ID] --name="My Awesome Project"
        ```
    * To create the project within a specific folder:
        ```bash
        gcloud projects create [YOUR_UNIQUE_PROJECT_ID] \
            --name="My Awesome Project" \
            --folder="[PARENT_FOLDER_ID]"
        ```
    * To create it directly under the organization:
         ```bash
        gcloud projects create [YOUR_UNIQUE_PROJECT_ID] \
            --name="My Awesome Project" \
            --organization="[YOUR_ORGANIZATION_ID]"
        ```

2.  **Link the project to a billing account (Crucial Step):**
    * First, list your available billing accounts:
        ```bash
        gcloud beta billing accounts list
        ```
    * Then, link your new project to one:
        ```bash
        gcloud beta billing projects link [YOUR_PROJECT_ID] \
            --billing-account [BILLING_ACCOUNT_ID]
        ```

### Necessary IAM Permissions for Management

| Role                                               | Description                                                                    |
| -------------------------------------------------- | ------------------------------------------------------------------------------ |
| **Folder Creator** (`roles/resourcemanager.folderCreator`) | Allows a user to create new folders within a resource.                         |
| **Project Creator** (`roles/resourcemanager.projectCreator`) | Allows a user to create new projects. They automatically become owner of the project. |
| **Organization Administrator** (`roles/resourcemanager.organizationAdmin`) | Full control over all resources within the organization.                       |

To grant a user the ability to create projects within a specific folder, an admin can run:

```bash
gcloud resource-manager folders add-iam-policy-binding [FOLDER_ID] \
    --member="user:[USER_EMAIL]" \
    --role="roles/resourcemanager.projectCreator"

# How to Create a Zonal GKE Autopilot Cluster

This guide provides instructions for creating a zonal Google Kubernetes Engine (GKE) cluster running in Autopilot mode.

An Autopilot cluster simplifies Kubernetes by having Google manage the underlying nodes, scaling, and security configurations. A **zonal** cluster has its control plane and nodes running within a single compute zone. This is often used for development, testing, or applications that do not require multi-zone high availability.

## Prerequisites

Before you begin, ensure you have the following:

1.  A Google Cloud project with billing enabled.
2.  The [Google Cloud SDK](https://cloud.google.com/sdk/docs/install) (`gcloud` CLI) installed and initialized.
3.  The Kubernetes Engine API enabled in your project. You can enable it with this command:
    ```bash
    gcloud services enable container.googleapis.com
    ```

---

## Method 1: Using the Google Cloud Console (GUI)

This method uses the web-based user interface.

1.  Navigate to the **Google Kubernetes Engine** page in the Cloud Console.
    * [Go to GKE](https://console.cloud.google.com/kubernetes/list)
2.  Click **CREATE**.
3.  In the `GKE Autopilot` section, click **CONFIGURE**.
4.  **Cluster basics:**
    * **Name:** Enter a unique name for your cluster (e.g., `my-zonal-cluster`).
    * **Location type:** Select **Zonal**.
    * **Region:** Choose the region that will contain your zone (e.g., `europe-west3`).
    * **Zone:** Select the specific zone for your cluster (e.g., `europe-west3-a`).
5.  You can configure optional settings in the left-hand navigation (like `Networking` or `Advanced options`), but the defaults are sufficient to get started.
6.  Click **CREATE** and wait for the cluster to be provisioned. This may take several minutes.

---

## Method 2: Using the `gcloud` Command-Line (CLI)

This method is faster for users who are comfortable with the command line.

1.  Open your terminal or Cloud Shell.
2.  Use the following command to create the cluster. Replace the placeholder values with your own.

    ```bash
    gcloud container clusters create-auto "your-cluster-name" \
        --project="your-project-id" \
        --zone="your-compute-zone"
    ```

3.  **Command Breakdown:**
    * `gcloud container clusters create-auto`: This is the command to create a GKE Autopilot cluster.
    * `"your-cluster-name"`: The name for your cluster (e.g., `dev-cluster-zonal`).
    * `--project`: (Optional) The ID of your Google Cloud project. This is only needed if you haven't set a default project in your `gcloud` configuration.
    * `--zone`: This flag specifies the single compute zone where the cluster will be created, making it a zonal cluster (e.g., `us-central1-c`). You can find available zones by running `gcloud compute zones list`.

4.  **Example Command:**
    ```bash
    gcloud container clusters create-auto "dev-cluster-zonal" \
        --zone="us-central1-c"
    ```
5.  The CLI will prompt you to confirm the creation. After you confirm, the process will begin.

---

## Verifying Your Cluster

Once the cluster is created, you need to configure `kubectl` to interact with it.

1.  Fetch the cluster credentials. This command automatically configures `kubectl` for you.
    ```bash
    gcloud container clusters get-credentials "your-cluster-name" \
        --zone="your-compute-zone"
    ```
    *Example:*
    ```bash
    gcloud container clusters get-credentials "dev-cluster-zonal" \
        --zone="us-central1-c"
    ```

2.  Verify the connection by listing the nodes. Since it's an Autopilot cluster, you won't see traditional nodes, but this confirms `kubectl` is working.
    ```bash
    kubectl get nodes
    ```
    You should see one or more nodes managed by GKE Autopilot.

## Cleaning Up

To avoid incurring ongoing charges, delete the cluster when you are finished.

1.  **Using the `gcloud` CLI:**
    ```bash
    gcloud container clusters delete "your-cluster-name" \
        --zone="your-compute-zone"
    ```

2.  **Using the Google Cloud Console:**
    * Go to the **GKE** page.
    * Select the checkbox next to your cluster.
    * Click the **DELETE** button at the top and confirm the deletion.

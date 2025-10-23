# Getting Started with Google Cloud Filestore in the Console 🚀

This guide provides a basic walkthrough to create a Google Cloud Filestore instance and mount it on a Compute Engine (GCE) VM. Filestore is a managed file storage service for applications that require a filesystem interface and a shared filesystem for data. It's essentially a fully managed Network Attached Storage (NAS) solution.

---

## Prerequisites

Before you begin, ensure you have the following:

* **A Google Cloud Project:** You need a project with billing enabled.
* **Permissions:** You need a role with permissions to create Filestore instances, VPC networks, and Compute Engine VMs (e.g., `roles/editor` or `roles/owner`).
* **gcloud CLI (Optional but recommended):** While this guide focuses on the Console, having the `gcloud` command-line tool installed is useful for verification.

---

## Step 1: Enable the Filestore API

APIs must be enabled before you can use a service.

1.  Navigate to the **APIs & Services > Library** page in the Google Cloud Console.
2.  Search for "**Cloud Filestore API**".
3.  Select it from the results and click **Enable**. If it's already enabled, you're all set.

---

## Step 2: Create a Filestore Instance

The Filestore instance is your managed NAS server.

1.  In the Cloud Console, navigate to the **Filestore** page (you can use the search bar at the top).
2.  Click **Create Instance**.
3.  **Instance ID:** Give your instance a unique name, like `my-first-fileshare`.
4.  **Tier:** Select **Basic SSD** or **Basic HDD** for this introductory example. The tier determines performance and capacity.
5.  **Capacity:** Set a capacity. The minimum for Basic tiers is **1 TiB**.
6.  **Region and Zone:** Choose a region and zone. **Important:** Your Filestore instance and the VM that will mount it **must be in the same region**.
7.  **VPC Network:** Select the `default` VPC network for simplicity. Filestore needs to be on the same network as the clients (VMs) that will access it.
8.  **File Share Name:** This is the name of the share on the Filestore instance. The default is `vol1`.
9.  Click **Create**. The instance will take a few minutes to provision.

Once created, note down its **IP address** from the Filestore instances list. You'll need it later.

---

## Step 3: Create a Compute Engine (GCE) VM

Now, create a Linux VM to act as the client that will connect to your file share.

1.  In the Cloud Console, navigate to **Compute Engine > VM instances**.
2.  Click **Create Instance**.
3.  **Name:** Give your VM a name, like `filestore-client-vm`.
4.  **Region and Zone:** Select the **same region** as your Filestore instance. The zone can be any within that region.
5.  **Machine Configuration:** A small machine type like `e2-micro` or `e2-small` is sufficient for this test.
6.  **Boot Disk:** The default Debian or Ubuntu Linux image is fine.
7.  **Networking:** Ensure the VM is being created in the **same VPC network** (`default`) that you selected for your Filestore instance.
8.  Click **Create**.

---

## Step 4: Mount the Filestore Share on the VM

Once the VM is running, you'll SSH into it and mount the network file share.

1.  On the **VM instances** page, find your `filestore-client-vm` and click the **SSH** button. This will open a terminal window in your browser.
2.  Inside the SSH terminal, install the NFS client tools.
    ```bash
    # For Debian/Ubuntu
    sudo apt-get update && sudo apt-get install -y nfs-common
    ```
3.  Create a directory on the VM where you will mount the Filestore share. This is your mount point.
    ```bash
    sudo mkdir -p /mnt/fileshare
    ```
4.  Mount the Filestore share using the `mount` command. Replace `FILESTORE_IP_ADDRESS` with the IP address of your Filestore instance and `vol1` with your file share name if you changed it.
    ```bash
    sudo mount FILESTORE_IP_ADDRESS:/vol1 /mnt/fileshare
    ```
    *Example:* `sudo mount 10.0.0.2:/vol1 /mnt/fileshare`

---

## Step 5: Verify the Mount

Let's confirm it worked and test file creation.

1.  Run the `df` (disk free) command to see all mounted filesystems. You should see your Filestore share listed.
    ```bash
    df -h --type=nfs4
    ```
    The output will look something like this:
    ```
    Filesystem               Size  Used Avail Use% Mounted on
    10.0.0.2:/vol1           1.0T  256K  1.0T   1% /mnt/fileshare
    ```
2.  Write a test file to the mounted directory. Since you mounted it with `sudo`, you'll need `sudo` to write to it initially.
    ```bash
    sudo touch /mnt/fileshare/test-file.txt
    ls -l /mnt/fileshare
    ```
    You should see `test-file.txt` listed. This file now exists on your Filestore instance, not on the local VM disk.

Congratulations! You have successfully created and mounted a Google Cloud Filestore share. 🎉

---

## Step 6: Cleaning Up

To avoid incurring ongoing charges, delete the resources you created.

1.  **Delete the GCE VM:** Go to the **Compute Engine** page, select your VM, and click **Delete**.
2.  **Delete the Filestore instance:** Go to the **Filestore** page, select your instance, and click **Delete**.

**Note:** Deleting the resources is permanent and will erase any data stored on the Filestore instance.

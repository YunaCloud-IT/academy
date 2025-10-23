# Getting Started with Google Cloud Persistent Disk

Welcome to this hands-on guide for Google Cloud's primary block storage service, **Persistent Disk**. This tutorial will walk you through the essential lifecycle of a block storage volume using the Google Cloud Console. Persistent Disks serve as durable and high-performance storage for your Virtual Machine (VM) instances. 🖥️

## Prerequisites

Before you begin, you'll need:
1.  A **Google Cloud Platform (GCP) Account** with billing enabled.
2.  A **Google Cloud Project**.
3.  Basic familiarity with Linux command-line operations.

---

## 1. Create a Standalone Persistent Disk

First, let's create a new, empty block storage volume. This is useful when you need to add more storage to an existing VM or prepare storage for a new one.

1.  **Navigate to Persistent Disk**: In the Google Cloud Console, use the navigation menu (≡) and go to `Compute Engine` > `Storage` > `Disks`.
2.  **Create Disk**: Click the **CREATE DISK** button at the top.
3.  **Configure the Disk**: Fill in the following details:
    * **Name**: `my-first-data-disk`
    * **Region and Zone**: Choose a region and zone, for example, `europe-west4` and `europe-west4-a`. **Important**: A disk can only be attached to a VM in the **same zone**.
    * **Disk source type**: Keep the default, **Blank disk**.
    * **Disk type**: Select **Balanced persistent disk** (`pd-balanced`). This offers a good mix of performance and cost for general use.
    * **Size**: Enter `10` GB.

4.  **Create**: Click the **CREATE** button at the bottom.

You've now provisioned a 10 GB block storage volume that exists independently of any VM.

---

## 2. Create a VM and Attach the Disk

A disk isn't very useful on its own. Let's create a new VM and attach the disk we just made as a secondary data disk.

1.  **Navigate to VM instances**: In the navigation menu, go to `Compute Engine` > `VM instances`.
2.  **Create Instance**: Click **CREATE INSTANCE**.
3.  **Configure the VM**:
    * **Name**: `storage-test-vm`
    * **Region and Zone**: Select the **exact same region and zone** you chose for your disk (e.g., `europe-west4-a`). This is critical.
    * **Machine configuration**: The default `e2-medium` is fine for this test.
    * **Boot disk**: The default Debian or Ubuntu Linux image is perfect.
4.  **Attach the Existing Disk**:
    * Scroll down to the **Advanced options** section and expand it.
    * Select **Disks**.
    * Under **Additional disks**, click **ATTACH EXISTING DISK**.
    * In the dropdown menu, select the disk you created: `my-first-data-disk`.
    * Ensure the **Mode** is `Read/write`.

5.  **Create**: Click the **CREATE** button.

Your VM will now be created with both a boot disk (containing the OS) and your new 10 GB data disk attached.

---

## 3. Format and Mount the Disk in Linux

Attaching a disk makes it available to the OS, but you still need to prepare it for use. This involves creating a filesystem (formatting) and attaching it to a directory (mounting).

1.  **SSH into the VM**: On the `VM instances` page, find your `storage-test-vm` and click the **SSH** button to open a terminal in your browser.

2.  **List Block Devices**: Run the `lsblk` command to see the attached disks. You should see `sda` (the boot disk) and `sdb` (your 10 GB data disk).

    ```bash
    lsblk
    ```
    *Output will look similar to this:*
    ```
    NAME    MAJ:MIN RM  SIZE RO TYPE MOUNTPOINT
    sda       8:0    0   10G  0 disk
    ├─sda1    8:1    0  9.9G  0 part /
    └─sda15   8:15   0  124M  0 part /boot/efi
    sdb       8:16   0   10G  0 disk
    ```

3.  **Format the Disk**: We will format our disk (`/dev/sdb`) with the `ext4` filesystem. **Warning**: This command erases all data on the target disk. Since ours is blank, it's safe.

    ```bash
    sudo mkfs.ext4 -m 0 -E lazy_itable_init=0,lazy_journal_init=0,discard /dev/sdb
    ```

4.  **Create a Mount Point**: This is the directory where the disk's filesystem will be accessible.

    ```bash
    sudo mkdir -p /mnt/data
    ```

5.  **Mount the Disk**: Attach the formatted disk to the mount point.

    ```bash
    sudo mount -o discard,defaults /dev/sdb /mnt/data
    ```

6.  **Set Permissions**: Change the permissions so you can write files to it.

    ```bash
    sudo chmod a+w /mnt/data
    ```

7.  **Verify**: Check that the disk is mounted correctly.

    ```bash
    df -h /mnt/data
    ```

You can now read and write data to the `/mnt/data` directory, and it will be stored on your Persistent Disk!

---

## 4. Create a Snapshot for Backup

Snapshots are point-in-time copies of your disk, essential for backups and disaster recovery.

1.  **Navigate to Snapshots**: Go to `Compute Engine` > `Storage` > `Snapshots`.
2.  **Create Snapshot**: Click **CREATE SNAPSHOT**.
3.  **Configure the Snapshot**:
    * **Name**: `my-first-snapshot`
    * **Source disk**: Select `my-first-data-disk` from the dropdown.
    * **Region**: Snapshots can be Regional or Multi-regional. For this test, leave the default `Regional` setting, matching the disk's region.
4.  **Create**: Click **CREATE**.

The snapshot will be created in the background. You can use this snapshot to create a new disk with the exact same data, even in a different zone.

---

## 5. Clean Up Resources

To avoid incurring charges, it's important to delete the resources you created.

1.  **Delete the VM Instance**:
    * Go to `Compute Engine` > `VM instances`.
    * Check the box next to `storage-test-vm`.
    * Click the **DELETE** button at the top.

2.  **Delete the Persistent Disk**:
    * **Important**: Deleting a VM does **not** delete any additional disks you attached to it. You must delete the disk separately.
    * Go to `Compute Engine` > `Storage` > `Disks`.
    * Check the box next to `my-first-data-disk`.
    * Click the **DELETE** button.

3.  **Delete the Snapshot**:
    * Go to `Compute Engine` > `Storage` > `Snapshots`.
    * Check the box next to `my-first-snapshot`.
    * Click the **DELETE** button.

Congratulations! You have successfully created, attached, used, backed up, and deleted a Google Cloud Persistent Disk. 🎉

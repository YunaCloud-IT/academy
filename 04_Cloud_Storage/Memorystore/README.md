# Quickstart: Getting Familiar with Cloud Memorystore (Redis) in the Console

This guide provides a step-by-step walkthrough on how to create, manage, and connect to a Google Cloud Memorystore for Redis instance entirely from within the Google Cloud Console. This is the fastest way to get hands-on experience with the service.

## Goal

* Provision a new Memorystore for Redis instance.
* Create a Compute Engine (GCE) VM to act as a client.
* Connect to the Redis instance from the VM and run basic commands.
* Clean up the resources.

## Prerequisites

1.  A Google Cloud Project with billing enabled.
2.  An IAM user with permissions to create/manage Memorystore and Compute Engine instances (e.g., `Editor` role).

---

## Step 1: Enable the Memorystore for Redis API

Before you can use Memorystore, you must enable its API in your project.

1.  In the Google Cloud Console, navigate to the **APIs & Services > Library**.
2.  In the search bar, type "Memorystore for Redis API".
3.  Click on the "Memorystore for Redis API" result.
4.  If the API is not enabled, click the **Enable** button. (If it's already enabled, you're all set).



---

## Step 2: Create a Memorystore for Redis Instance

Now, let's provision the actual in-memory cache.

1.  From the main navigation menu (☰), scroll down to **Storage** and select **Memorystore > Redis**.
2.  Click **Create Instance**.
3.  Fill out the instance configuration form:
    * **Instance ID:** Give it a unique name, like `my-first-cache`.
    * **Tier:** Select **Basic**. This is perfect for development and testing (it's a standalone node, not a high-availability pair).
    * **Capacity:** Choose the minimum, **1 GB**.
    * **Region:** Select a region, for example, `us-central1`. **(Remember this choice!)**
    * **Zone:** You can leave this as `Any`.
    * **Authorized network:** Select `default`. This is the VPC network your instance will be available on. **(Remember this choice!)**
4.  All other settings (like Redis version) can be left as the default.
5.  Click **Create**.

The instance will take a few minutes to provision. Wait until you see a green checkmark next to its name in the instance list.

---

## Step 3: Create a Compute Engine (GCE) VM Client

You cannot connect to a Memorystore instance from the public internet; you must connect from a resource *within the same VPC network and region*. The easiest way to test this is with a GCE VM.

1.  From the navigation menu (☰), go to **Compute Engine > VM instances**.
2.  Click **Create Instance**.
3.  Configure the VM:
    * **Name:** `memorystore-test-client`.
    * **Region:** Select the *exact same region* you chose for your Redis instance (e.g., `us-central1`).
    * **Zone:** Select any zone within that region (e.g., `us-central1-a`).
    * **Machine type:** You can use a cheap one, like `e2-micro`.
    * **Boot disk:** Leave as the default (e.g., Debian 11).
    * **Firewall:** Check **Allow HTTP traffic** (not needed for Redis, but good practice if you install a web app later).
4.  **Crucial Step (Networking):**
    * Expand the **Advanced options > Networking** section.
    * Under **Networking > Network interfaces**, ensure the **Network** selected is `default` (or the same VPC you chose in Step 2).
5.  Click **Create**.

---

## Step 4: Connect and Test Your Instance

Once both your Redis instance and your VM are running (green checkmarks), it's time to connect.

1.  **Get your Redis IP:**
    * Go back to the **Memorystore > Redis** page.
    * Click on your instance ID (`my-first-cache`).
    * On the details page, find the **Host IP** (it will look something like `10.128.0.3`).
    * Copy this IP address.

2.  **SSH into your VM:**
    * Go to the **Compute Engine > VM instances** page.
    * In the row for `memorystore-test-client`, click the **SSH** button.
    * A new browser window will open with a command-line terminal for your VM.

3.  **Install Redis Tools:**
    * In the VM's SSH terminal, first update the package list, then install `redis-tools`, which includes the `redis-cli` command-line interface:
    ```bash
    sudo apt-get update
    sudo apt-get install -y redis-tools
    ```

4.  **Connect to your Redis instance:**
    * Use the `redis-cli` command. Replace `[YOUR_REDIS_IP]` with the Host IP you copied in step 4.1. The default port is `6379`.
    ```bash
    redis-cli -h [YOUR_REDIS_IP] -p 6379
    ```
    * **Example:** `redis-cli -h 10.128.0.3 -p 6379`

5.  **Run Redis Commands:**
    * If successful, your prompt will change to `[YOUR_REDIS_IP]:6379>`.
    * Test the connection with `ping`:
    ```redis
    ping
    ```
    * You should see the reply: `PONG`
    * Now, try setting and getting a key:
    ```redis
    set mykey "Hello from Memorystore!"
    # You should see: OK
    
    get mykey
    # You should see: "Hello from Memorystore!"
    
    exit
    ```

You are now back at your VM's bash prompt. You have successfully connected to and used your Memorystore instance!

---

## Step 5: Clean Up

To avoid incurring charges on your Google Cloud bill, delete the resources you created.

1.  **Delete the Memorystore Instance:**
    * Go to **Memorystore > Redis**.
    * Select the checkbox next to `my-first-cache`.
    * Click the **Delete** button at the top and confirm.

2.  **Delete the VM Instance:**
    * Go to **Compute Engine > VM instances**.
    * Select the checkbox next to `memorystore-test-client`.
    * Click the **Delete** button at the top and confirm.

You have now completed the full lifecycle of creating, using, and destroying a Memorystore instance.

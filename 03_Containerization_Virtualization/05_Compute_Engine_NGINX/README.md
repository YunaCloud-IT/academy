# Creating a Google Cloud Linux VM and Installing NGINX

This guide provides a step-by-step walkthrough for creating a Linux Virtual Machine (VM) in Google Cloud Platform (GCP) and installing the NGINX web server.

## 1. Create the Virtual Machine Instance

First, we will provision a new VM instance using the Google Cloud Console.

1.  Sign in to the [Google Cloud Console](https://console.cloud.google.com/).
2.  From the main navigation menu (☰), go to **Compute Engine** > **VM instances**.
3.  Click **CREATE INSTANCE**.
4.  **Configure the instance:**
    * **Name:** Give your virtual machine a unique name (e.g., `nginx-server`).
    * **Region and Zone:** Select a region and zone. Choose a location that is geographically close to your users for lower latency.
    * **Machine configuration:** Select a machine type based on your needs. For a simple test server, a small instance from the E2 series (like `e2-micro`) is a cost-effective choice.
5.  **Configure Firewall Access:**
    * In the **Firewall** section, check the box to **Allow HTTP traffic**. This creates a firewall rule to open port 80, allowing web traffic to reach your NGINX server.
6.  Review the other settings, such as the Boot disk (defaulting to Debian Linux is fine for this guide), and click **Create**.

Wait a minute for the instance to be provisioned and started.

## 2. Install and Start NGINX

Next, you will connect to the new VM using SSH and install the NGINX software.

1.  On the **VM instances** page, find your newly created VM in the list.
2.  In the `Connect` column, click **SSH**. This will open a secure terminal session directly in your browser.
3.  Inside the terminal, run the following commands to install and start NGINX.

    ```bash
    # Switch to the root user for administrative privileges
    sudo su -
    
    # Update the system's package list
    apt-get update
    
    # Install the NGINX package (-y confirms the installation)
    apt-get install -y nginx
    
    # Start the NGINX service
    service nginx start
    ```

## 3. Verify the Installation

Confirm that your web server is running and accessible from the internet.

1.  Return to the **VM instances** page in the Cloud Console.
2.  Find the **External IP** address for your VM instance.
3.  Click the IP address (or copy and paste it into a new browser tab).

You should now see the default "Welcome to nginx!" page, confirming that your installation was successful.

## 4. Clean Up

To avoid incurring unexpected costs, it is important to delete the resources you are no longer using.

1.  In the Cloud Console, navigate back to the **VM instances** page.
2.  Select the checkbox next to the VM you created.
3.  Click the **DELETE** button at the top of the page and confirm the deletion.

# How to Create a Custom VPC in Google Cloud

This guide explains how to create a custom-mode Virtual Private Cloud (VPC) in Google Cloud Platform (GCP). While every GCP project starts with a `default` VPC, creating a custom VPC gives you complete control over your network's IP address ranges and subnets.

### Key Concepts
* **VPC Network:** A global, private network that provides connectivity for your GCP resources. It is a logical isolation of a section of the Google Cloud.
* **Subnet (Subnetwork):** A regional, partitioned IP address range within your VPC. All Compute Engine VMs and other resources must belong to a subnet.
* **Firewall Rules:** Control ingress (incoming) and egress (outgoing) traffic for resources within your VPC. **Crucially, custom VPCs have no default firewall rules, so all incoming traffic is blocked until you create rules to allow it.**

## Prerequisites

* A Google Cloud project with billing enabled.
* Permissions to manage networks and firewall rules, such as the `Compute Network Admin` role (`roles/compute.networkAdmin`).
* The [Google Cloud SDK](https://cloud.google.com/sdk/docs/install) (`gcloud` CLI) installed and configured (for the CLI methods).

---

## Step 1: Create the VPC Network

First, create the VPC container itself, specifying that it will have custom subnets.

### Method A: Using the Google Cloud Console

1.  In the Google Cloud Console, navigate to **VPC network** > **VPC networks**.
    * [Go to VPC Networks](https://console.cloud.google.com/vpc/networks)
2.  Click **CREATE VPC NETWORK**.
3.  Enter a **Name** for your VPC (e.g., `my-custom-network`).
4.  Under **Subnets**, for the **Subnet creation mode**, select **Custom**.
5.  Do not click create yet. Proceed to the next step to add a subnet.

### Method B: Using the `gcloud` CLI

Run the following command to create the VPC without any subnets.
```bash
gcloud compute networks create my-custom-network \
    --subnet-mode=custom

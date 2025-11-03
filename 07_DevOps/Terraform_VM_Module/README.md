# Provision a Google Cloud VM with Terraform

This guide provides the steps and example code to provision a simple virtual machine (VM) instance on Google Cloud Platform (GCP) using Terraform.

##  Prerequisites

Before you begin, ensure you have the following:

1.  **Google Cloud Platform (GCP) Account:** You need an active GCP account with billing enabled.
2.  **GCP Project:** Create a new GCP project or use an existing one. Note your Project ID.
3.  **Google Cloud SDK (`gcloud`):** [Install the Google Cloud SDK](https://cloud.google.com/sdk/docs/install) and initialize it:
    ```bash
    gcloud init
    ```
4.  **Enable Compute Engine API:** You must enable the Compute Engine API in your GCP project. You can do this via the web console or:
    ```bash
    gcloud services enable compute.googleapis.com
    ```
5.  **Terraform:** [Install Terraform](https://learn.hashicorp.com/tutorials/terraform/install-cli) on your local machine.
6.  **Authentication:** Terraform needs to authenticate with GCP. The simplest way for local development is using Application Default Credentials (ADC) by running:
    ```bash
    gcloud auth application-default login
    ```
    For production or CI/CD, it's recommended to use a [Service Account](https://cloud.google.com/iam/docs/service-accounts) with appropriate permissions (e.g., Compute Admin) and provide the key file to Terraform.

---

## 1. Set Up Your Terraform Configuration

Create a directory for your Terraform project and add a file named `main.tf`.

```bash
mkdir gcp-vm-terraform
cd gcp-vm-terraform
touch main.tf
```

Paste the following configuration into your `main.tf` file.

```terraform
# Configure the Terraform settings, specifying the required Google provider
terraform {
  required_providers {
    google = {
      source  = "hashicorp/google"
      version = "~> 5.0" # Use a recent version
    }
  }
}

# Configure the Google Cloud provider
provider "google" {
  # Replace this with your Project ID from Google Cloud Console
  project     = "YOUR_PROJECT_ID"
  region      = "europe-west10"
  zone        = "europe-west10-c"
}

# 1. Create a VPC Network
# Although a 'default' network exists, it's good practice to create one.
resource "google_compute_network" "vpc_network" {
  name                    = "terraform-network"
  auto_create_subnetworks = true # Automatically create subnetworks in each region
}

# 2. Define the Compute Engine VM Instance
resource "google_compute_instance" "vm_instance" {
  name         = "terraform-instance"
  machine_type = "e2-medium"      # A small, cost-effective machine type
  zone         = "europe-west10-c" # Change this to your desired zone

  # Define the boot disk and image
  boot_disk {
    initialize_params {
      image = "debian-cloud/debian-11" # Specify the image
    }
  }

  # Define the network interface
  network_interface {
    # Use the network created above
    network = google_compute_network.vpc_network.id

    # An access_config block is required to assign an ephemeral public IP
    access_config {
      // Ephemeral IP
    }
  }

  # Add metadata for a startup script (optional)
  metadata_startup_script = <<-EOT
    #!/bin/bash
    echo "Hello, World!" > /home/user/hello.txt
  EOT

  # Add tags (optional)
  tags = ["web", "dev"]
}

# 3. (Optional) Output the VM's IP address
output "instance_ip_address" {
  description = "The external IP address of the VM instance"
  value       = google_compute_instance.vm_instance.network_interface[0].access_config[0].nat_ip
}
```

Note: Remember to replace values like `project`, `region`, and `zone` if you are not relying on environment variables or the `gcloud` config. In this example, the provider block is minimal as it will infer the project and credentials from your `gcloud` ADC setup.

## 2. Initialize and Apply the Configuration

Now, run the standard Terraform workflow from your terminal within the `gcp-vm-terraform` directory.

### Step 1: Initialize Terraform

This command downloads the Google provider plugin defined in your `main.tf` file.

```Bash
terraform init
```

### Step 2: Plan the Changes

This command creates an execution plan. It shows you what resources Terraform will create, modify, or destroy. This is a dry run and is safe to run multiple times.

```
terraform plan
```

You should see output indicating that one `google_compute_network` and one `google_compute_instance` will be created.

### Step 3: Apply the Configuration

This command applies the changes and provisions the resources in GCP.

```
terraform apply
```

Terraform will show you the plan again and ask for confirmation. Type `yes` and press Enter to proceed.

Once complete, Terraform will provision the network and the VM. If you included the `output` block, it will also display the VM's external IP address.

## 3. Verify the VM

You can verify the VM's creation in the GCP Console under Compute Engine > VM instances.

You can also use gcloud to SSH into the instance:

```
# Make sure to use the correct zone and instance name
gcloud compute ssh terraform-instance --zone=us-central1-a
```

## 4. Clean Up Resources

When you are finished with the VM, you can destroy all the resources created by Terraform to avoid incurring further charges.

```
terraform destroy
```

Terraform will show you all the resources that will be deleted and ask for confirmation. Type `yes` to approve the deletion.

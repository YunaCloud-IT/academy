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
  project     = "ams-iot-1"
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
  machine_type = var.vm_machine_type
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

variable "vm_machine_type" {
  type = string
  default = "e2-micro"
}

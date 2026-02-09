# 1. VPC Network
resource "google_compute_network" "vpc_network" {
  name                    = var.network_name
  auto_create_subnetworks = false
}

# 2. Subnet
resource "google_compute_subnetwork" "subnetwork" {
  name          = "subnet-${var.region}"
  ip_cidr_range = var.subnet_cidr
  region        = var.region
  network       = google_compute_network.vpc_network.id
}

# 3. Firewall Rule
resource "google_compute_firewall" "allow_http_ssh" {
  name    = "allow-http-ssh"
  network = google_compute_network.vpc_network.id

  allow {
    protocol = "tcp"
    ports    = ["80", "22"]
  }

  source_ranges = ["0.0.0.0/0"]
  target_tags   = ["web-server"]
}

# 4. Virtual Machine
resource "google_compute_instance" "vm_instance" {
  name         = "nginx-vm"
  machine_type = var.machine_type
  zone         = var.zone
  tags         = ["web-server"]

  boot_disk {
    initialize_params {
      image = "debian-cloud/debian-11"
    }
  }

  network_interface {
    subnetwork = google_compute_subnetwork.subnetwork.id
    access_config {
      # Ephemeral public IP
    }
  }

  # Load the script from the external file
  metadata_startup_script = file("${path.module}/startup.sh")
}

output "vm_public_ip" {
  description = "The public IP address of the Nginx server"
  value       = google_compute_instance.vm_instance.network_interface[0].access_config[0].nat_ip
}

output "vpc_name" {
  description = "The name of the created VPC"
  value       = google_compute_network.vpc_network.name
}

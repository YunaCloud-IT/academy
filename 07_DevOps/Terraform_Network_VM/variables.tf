variable "project_id" {
  description = "The GCP project ID"
  type        = string
}

variable "region" {
  description = "The GCP region to deploy to"
  type        = string
  default     = "europe-west10"
}

variable "zone" {
  description = "The GCP zone to deploy to"
  type        = string
  default     = "europe-west10-a"
}

variable "network_name" {
  description = "The name of the VPC network"
  type        = string
  default     = "vpc-network-terraform"
}

variable "machine_type" {
  description = "The machine type for the VM"
  type        = string
  default     = "e2-small"
}

variable "subnet_cidr" {
  description = "The CIDR range for the subnet"
  type        = string
  default     = "10.0.1.0/24"
}

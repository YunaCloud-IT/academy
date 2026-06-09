variable "project_id" {
  description = "The GCP project to use for integration tests"
  type        = string
  default       = "iot-srh-group-2" # "YOUR_PROJECT_ID"
}

variable "region" {
  description = "The GCP region to create and test resources in"
  type        = string
  default     = "europe-west10"
}

variable "zone" {
  description = "The GCP zone to create resources in"
  type        = string
  default     = "europe-west10-c"
}

variable "subnetwork" {
  description = "The subnetwork selflink to host the compute instances in"
  default = "default"
}

variable "num_instances" {
  description = "Number of instances to create"
  type = number
  default = 1
}

variable "machine_type" {
  default = "e2-micro"
  type = string
  description = "Specific Machine Type"
}

variable "nat_ip" {
  description = "Public ip address"
  default     = null
}

variable "network_tier" {
  description = "Network network_tier"
  default     = "PREMIUM"
}

variable "service_account" {
  default = { email: "460549935395-compute@developer.gserviceaccount.com", scopes: [] }
  type = object({
    email  = string,
    scopes = set(string)
  })
  description = "Service account to attach to the instance. See https://www.terraform.io/docs/providers/google/r/compute_instance_template#service_account."
}

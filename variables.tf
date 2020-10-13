variable "firewall_rules" {
  description = "An map of configurations for firewall rules"

  default = [
    {
      name          = "allow-health-check"
      source_ranges = ["130.211.0.0/22", "35.191.0.0/16", "209.85.152.0/22", "209.85.204.0/22"]

      allow = {
        protocol = "tcp"
      }
    },
    {
      name          = "allow-ssh-ingress-from-iap"
      source_ranges = ["35.235.240.0/20"]

      allow = {
        protocol = "tcp"
        ports    = ["22"]
      }

    }
  ]
}

variable "project_id" {
  description = "The Project ID"
  type        = string
}

variable "secondary_ranges" {
  description = "A map of configurations for secondary IP ranges"
  type        = map(list(object({ range_name = string, ip_cidr_range = string })))

  default = {}
}

variable "services" {
  description = "The service to enable"
  type        = list(string)

  default = [
    "compute.googleapis.com",
  ]
}

variable "shared_vpc" {
  type        = bool
  description = "Enable VPC sharing"

  default = false
}

variable "subnets" {
  description = "An map of configurations for subnet"
  type        = list(map(string))
}

variable "vpc_name" {
  description = "Name of the VPC"
  type        = string
}

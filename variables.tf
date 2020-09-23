variable "project_id" {
  description = "The Project ID"
  type        = string
}

variable "shared_vpc_name" {
  description = "Name of the shared VPC"
  type        = string
}

variable "services" {
  description = "The service to enable"
  type        = list(string)

  default = [
    "compute.googleapis.com",
    "container.googleapis.com",
  ]
}

variable "subnets" {
  description = "An array of configurations for subnet"
  type        = list(map(string))
}

variable "secondary_ranges" {
  description = "An array of configurations for secondary IP ranges for VM instances contained in this subnetwork"
  type        = map(list(object({ range_name = string, ip_cidr_range = string })))
  default     = {}
}

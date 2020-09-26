variable "project_id" {
  description = "The Project ID"
  type        = string
}

variable "secondary_ranges" {
  description = "A map of configurations for secondary IP ranges"
  type        = map(list(object({ range_name = string, ip_cidr_range = string })))
  default     = {}
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
  default     = false
}

variable "subnets" {
  description = "An map of configurations for subnet"
  type        = list(map(string))
}

variable "vpc_name" {
  description = "Name of the VPC"
  type        = string
}

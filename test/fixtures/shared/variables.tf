variable "secondary_ranges" {
  type    = map(list(object({ range_name = string, ip_cidr_range = string })))
  default = {}
}

variable "cidr_range" {
  type    = string
  default = "172.23.21.0/24"
}

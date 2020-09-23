# Project Service Resource
# https://www.terraform.io/docs/providers/google/r/google_project_service.html

resource "google_project_service" "shared_vpc_service" {
  project = var.project_id
  count   = length(var.services)
  service = element(var.services, count.index)

  disable_on_destroy = false
}

# Compute Network Resource
# https://www.terraform.io/docs/providers/google/r/compute_network.html

resource "google_compute_network" "shared_vpc" {
  project                 = var.project_id
  name                    = var.shared_vpc_name
  auto_create_subnetworks = "false"
  routing_mode            = "GLOBAL"

  depends_on = [google_project_service.shared_vpc_service]
}

# Compute Subnetwork Resource
# https://www.terraform.io/docs/providers/google/r/compute_subnetwork.html

resource "google_compute_subnetwork" "shared_subnet" {
  provider = google-beta

  project       = var.project_id
  count         = length(var.subnets)
  name          = var.subnets[count.index]["subnet_name"]
  ip_cidr_range = var.subnets[count.index]["subnet_range"]
  region        = var.subnets[count.index]["subnet_region"]
  network       = google_compute_network.shared_vpc.self_link
  dynamic "log_config" {
    for_each = lookup(var.subnets[count.index], "subnet_flow_logs", false) ? [{
      aggregation_interval = lookup(var.subnets[count.index], "subnet_flow_logs_interval", "INTERVAL_5_SEC")
      flow_sampling        = lookup(var.subnets[count.index], "subnet_flow_logs_sampling", "0.5")
      metadata             = lookup(var.subnets[count.index], "subnet_flow_logs_metadata", "INCLUDE_ALL_METADATA")
    }] : []
    content {
      aggregation_interval = log_config.value.aggregation_interval
      flow_sampling        = log_config.value.flow_sampling
      metadata             = log_config.value.metadata
    }
  }

  secondary_ip_range = [
    for i in range(
      length(
        contains(
        keys(var.secondary_ranges), var.subnets[count.index]["subnet_name"]) == true
        ? var.secondary_ranges[var.subnets[count.index]["subnet_name"]]
        : []
    )) :
  var.secondary_ranges[var.subnets[count.index]["subnet_name"]][i]]
}

# Compute Shared VPC Host Resource
# https://www.terraform.io/docs/providers/google/r/compute_shared_vpc_host_project.html

resource "google_compute_shared_vpc_host_project" "shared_vpc" {
  project = var.project_id
}

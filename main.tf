# Project Service Resource
# https://www.terraform.io/docs/providers/google/r/google_project_service.html

resource "google_project_service" "this" {
  count = length(var.services)

  project = var.project_id
  service = element(var.services, count.index)

  disable_on_destroy = false
}

# Compute Network Resource
# https://www.terraform.io/docs/providers/google/r/compute_network.html

resource "google_compute_network" "this" {
  project                 = var.project_id
  name                    = var.vpc_name
  auto_create_subnetworks = "false"
  routing_mode            = "GLOBAL"

  depends_on = [google_project_service.this]
}

# Compute Subnetwork Resource
# https://www.terraform.io/docs/providers/google/r/compute_subnetwork.html

resource "google_compute_subnetwork" "this" {
  provider = google-beta

  count = length(var.subnets)

  project       = var.project_id
  name          = var.subnets[count.index]["subnet_name"]
  ip_cidr_range = var.subnets[count.index]["subnet_range"]
  region        = var.subnets[count.index]["subnet_region"]
  network       = google_compute_network.this.self_link

  log_config {
    aggregation_interval = "INTERVAL_5_SEC"
    flow_sampling        = 0.5
    metadata             = "INCLUDE_ALL_METADATA"
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

# Firewall Resource
# https://www.terraform.io/docs/providers/google/r/compute_firewall.html

resource "google_compute_firewall" "this" {
  count = length(var.firewall_rules)

  project       = var.project_id
  name          = "${google_compute_network.this.name}-${var.firewall_rules[count.index]["name"]}"
  network       = google_compute_network.this.name
  source_ranges = var.firewall_rules[count.index]["source_ranges"]

  dynamic "allow" {
    for_each = [lookup(var.firewall_rules[count.index], "allow")]
    content {
      protocol = allow.value.protocol
      ports    = lookup(allow.value, "ports", null)
    }
  }

}

# Compute Shared VPC Host Resource
# https://www.terraform.io/docs/providers/google/r/compute_shared_vpc_host_project.html

resource "google_compute_shared_vpc_host_project" "this" {
  count = var.shared_vpc ? 1 : 0

  project = var.project_id
}

resource "google_project_service" "this" {
  project = var.project_id
  count   = length(var.services)
  service = element(var.services, count.index)

  disable_on_destroy = false
}

resource "google_compute_network" "this" {
  project                 = var.project_id
  name                    = var.vpc_name
  auto_create_subnetworks = "false"
  routing_mode            = "GLOBAL"

  depends_on = [google_project_service.this]
}

resource "google_compute_subnetwork" "this" {
  project       = var.project_id
  count         = length(var.subnets)
  name          = var.subnets[count.index]["subnet_name"]
  ip_cidr_range = var.subnets[count.index]["subnet_range"]
  region        = var.subnets[count.index]["subnet_region"]
  network       = google_compute_network.this.self_link
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

resource "google_compute_firewall" "fw_allow_health_check" {
  project = var.project_id
  name    = "${google_compute_network.this.name}-allow-health-check"
  network = google_compute_network.this.name

  allow {
    protocol = "tcp"
  }

  source_ranges = ["35.191.0.0/16", "130.211.0.0/22"]
}

resource "google_compute_shared_vpc_host_project" "this" {
  count   = var.shared_vpc ? 1 : 0
  project = var.project_id
}

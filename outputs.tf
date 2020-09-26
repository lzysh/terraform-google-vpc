output "network_name" {
  value = google_compute_network.this.name
}

output "project_id" {
  value = var.project_id
}

output "subnet_ips" {
  value = [for network in google_compute_subnetwork.this : network.ip_cidr_range]
}

output "vpc_self_link" {
  value = google_compute_network.this.self_link
}

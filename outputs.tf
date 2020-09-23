output "shared_vpc_self_link" {
  value = google_compute_network.shared_vpc.self_link
}

output "network_name" {
  value = google_compute_network.shared_vpc.name
}

output "subnet_ips" {
  value = [for network in google_compute_subnetwork.shared_subnet : network.ip_cidr_range]
}

output "project_id" {
  value = var.project_id
}

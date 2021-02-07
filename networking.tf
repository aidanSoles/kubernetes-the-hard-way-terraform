resource "google_compute_address" "k8s_staticip" {
  name   = "k8s-staticip"
  region = var.region
}

resource "google_compute_firewall" "k8s_externalfirewall" {
  name    = "k8s-externalfirewall"
  network = google_compute_network.k8s_network.name

  allow {
    protocol = "icmp"
  }

  allow {
    protocol = "tcp"
  }

  source_ranges = ["0.0.0.0/0"]
}

resource "google_compute_firewall" "k8s_internalfirewall" {
  allow {
    protocol = "icmp"
  }

  allow {
    protocol = "tcp"
  }

  allow {
    protocol = "udp"
  }

  name    = "k8s-internalfirewall"
  network = google_compute_network.k8s_network.name

  source_ranges = ["0.0.0.0/0"]

  # source_ranges = ["${google_compute_subnetwork.k8s_subnet.ip_cidr_range}"]
}

resource "google_compute_firewall" "k8s_lbfirewall" {
  allow {
    protocol = "tcp"
  }

  name    = "k8s-lbfirewall"
  network = google_compute_network.k8s_network.name

  source_ranges = ["0.0.0.0/0"]

  # source_ranges = ["209.85.152.0/22", "209.85.204.0/22", "35.191.0.0/16"]
}

resource "google_compute_forwarding_rule" "k8s_lbforwarding" {
  ip_address = google_compute_address.k8s_staticip.address
  name       = "k8s-lbforwarding"
  port_range = "6443"
  target     = google_compute_target_pool.k8s_lbtartgetpool.self_link
}

resource "google_compute_http_health_check" "k8s_lbhealthcheck" {
  host         = "kubernetes.default.svc.cluster.local"
  name         = "k8s-lbhealthcheck"
  request_path = "/healthz"
}

resource "google_compute_network" "k8s_network" {
  auto_create_subnetworks = false
  name                    = "k8s-network"
}

resource "google_compute_subnetwork" "k8s_subnet" {
  name          = "k8s-subnet"
  ip_cidr_range = "10.0.0.0/24"
  region        = var.region
  network       = google_compute_network.k8s_network.self_link
}

resource "google_compute_route" "k8s_worker0route" {
  name        = "k8s-worker0route"
  depends_on  = [google_compute_instance.k8s_worker]
  dest_range  = "10.200.0.0/24"
  network     = google_compute_network.k8s_network.self_link
  next_hop_ip = google_compute_instance.k8s_worker.0.network_interface.0.network_ip
  priority    = 100
}

resource "google_compute_route" "k8s_worker1route" {
  name        = "k8s-worker1route"
  dest_range  = "10.200.1.0/24"
  depends_on  = [google_compute_instance.k8s_worker]
  network     = google_compute_network.k8s_network.self_link
  next_hop_ip = google_compute_instance.k8s_worker.1.network_interface.0.network_ip
  priority    = 100
}

resource "google_compute_route" "k8s_worker2route" {
  name        = "k8s-worker2route"
  dest_range  = "10.200.2.0/24"
  depends_on  = [google_compute_instance.k8s_worker]
  network     = google_compute_network.k8s_network.self_link
  next_hop_ip = google_compute_instance.k8s_worker.2.network_interface.0.network_ip
  priority    = 100
}

resource "google_compute_target_pool" "k8s_lbtartgetpool" {
  name = "k8s-lbtartgetpool"

  instances = [
    "${var.region}-${lookup(var.zone_map, 0)}/${google_compute_instance.k8s_controller.0.name}",
    "${var.region}-${lookup(var.zone_map, 1)}/${google_compute_instance.k8s_controller.1.name}",
    "${var.region}-${lookup(var.zone_map, 2)}/${google_compute_instance.k8s_controller.2.name}",
  ]

  health_checks = [
    "google_compute_http_health_check.k8s_lbhealthcheck.name",
  ]
}

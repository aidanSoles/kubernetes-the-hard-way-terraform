output "k8s-controllersprivateips" {
  value = google_compute_instance.k8s_controller.*.network_interface.0.network_ip
}

output "k8s-controllerspublicips" {
  value = google_compute_instance.k8s_controller.*.network_interface.0.access_config.0.nat_ip
}

output "k8s-staticip" {
  value = google_compute_address.k8s_staticip.address
}

output "k8s-workersprivateips" {
  value = google_compute_instance.k8s_worker.*.network_interface.0.network_ip
}

output "k8s-workerspublicips" {
  value = google_compute_instance.k8s_worker.*.network_interface.0.access_config.0.nat_ip
}


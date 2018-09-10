resource "google_compute_instance" "k8s_controller" {
  boot_disk {
    auto_delete = true

    initialize_params {
      image = "${var.controller_image}"
      size  = "${var.controller_size}"
    }
  }

  can_ip_forward = true
  count          = "${var.controller_count}"
  machine_type   = "${var.controller_type}"
  name           = "k8s-controller${count.index}"

  network_interface {
    access_config = {}
    subnetwork    = "${google_compute_subnetwork.k8s_subnet.name}"
  }

  metadata {
    creator = "${var.user}"
  }

  provisioner "file" {
    connection {
      private_key = "${file(var.ssh_path)}"
      user        = "${var.user}"
      type        = "ssh"
    }

    destination = "add-ssh-keys.sh"
    source      = "${var.scripts_path}/add-ssh-keys.sh"
  }

  provisioner "file" {
    connection {
      private_key = "${file(var.ssh_path)}"
      user        = "${var.user}"
      type        = "ssh"
    }

    destination = "admin.pem"
    source      = "${var.certs_path}/admin.pem"
  }

  provisioner "file" {
    connection {
      private_key = "${file(var.ssh_path)}"
      user        = "${var.user}"
      type        = "ssh"
    }

    destination = "admin-key.pem"
    source      = "${var.certs_path}/admin-key.pem"
  }

  provisioner "file" {
    connection {
      private_key = "${file(var.ssh_path)}"
      user        = "${var.user}"
      type        = "ssh"
    }

    destination = "ca.pem"
    source      = "${var.certs_path}/ca.pem"
  }

  provisioner "file" {
    connection {
      private_key = "${file(var.ssh_path)}"
      user        = "${var.user}"
      type        = "ssh"
    }

    destination = "ca-config.json"
    source      = "${var.certs_path}/ca-config.json"
  }

  provisioner "file" {
    connection {
      private_key = "${file(var.ssh_path)}"
      user        = "${var.user}"
      type        = "ssh"
    }

    destination = "ca-key.pem"
    source      = "${var.certs_path}/ca-key.pem"
  }

  provisioner "file" {
    connection {
      private_key = "${file(var.ssh_path)}"
      user        = "${var.user}"
      type        = "ssh"
    }

    destination = "create-rbac.sh"
    source      = "${var.scripts_path}/create-rbac.sh"
  }

  provisioner "file" {
    connection {
      private_key = "${file(var.ssh_path)}"
      user        = "${var.user}"
      type        = "ssh"
    }

    destination = "encryption-config.yaml"
    source      = "${var.configs_path}/encryption-config.yaml"
  }

  provisioner "file" {
    connection {
      private_key = "${file(var.ssh_path)}"
      user        = "${var.user}"
      type        = "ssh"
    }

    destination = "gen-admin-config.sh"
    source      = "${var.scripts_path}/gen-admin-config.sh"
  }

  provisioner "file" {
    connection {
      private_key = "${file(var.ssh_path)}"
      user        = "${var.user}"
      type        = "ssh"
    }

    destination = "gen-api-server-certs.sh"
    source      = "${var.scripts_path}/gen-api-server-certs.sh"
  }

  provisioner "file" {
    connection {
      private_key = "${file(var.ssh_path)}"
      user        = "${var.user}"
      type        = "ssh"
    }

    destination = "gen-controller-manager-config.sh"
    source      = "${var.scripts_path}/gen-controller-manager-config.sh"
  }

  provisioner "file" {
    connection {
      private_key = "${file(var.ssh_path)}"
      user        = "${var.user}"
      type        = "ssh"
    }

    destination = "gen-scheduler-config.sh"
    source      = "${var.scripts_path}/gen-scheduler-config.sh"
  }

  provisioner "file" {
    connection {
      private_key = "${file(var.ssh_path)}"
      user        = "${var.user}"
      type        = "ssh"
    }

    destination = "install-controller.sh"
    source      = "${var.scripts_path}/install-controller.sh"
  }

  provisioner "file" {
    connection {
      private_key = "${file(var.ssh_path)}"
      user        = "${var.user}"
      type        = "ssh"
    }

    destination = "kubernetes-csr.json"
    source      = "${var.certs_path}/kubernetes-csr.json"
  }

  provisioner "file" {
    connection {
      private_key = "${file(var.ssh_path)}"
      user        = "${var.user}"
      type        = "ssh"
    }

    destination = "kube-controller-manager.pem"
    source      = "${var.certs_path}/kube-controller-manager.pem"
  }

  provisioner "file" {
    connection {
      private_key = "${file(var.ssh_path)}"
      user        = "${var.user}"
      type        = "ssh"
    }

    destination = "kube-controller-manager-key.pem"
    source      = "${var.certs_path}/kube-controller-manager-key.pem"
  }

  provisioner "file" {
    connection {
      private_key = "${file(var.ssh_path)}"
      user        = "${var.user}"
      type        = "ssh"
    }

    destination = "kube-scheduler.pem"
    source      = "${var.certs_path}/kube-scheduler.pem"
  }

  provisioner "file" {
    connection {
      private_key = "${file(var.ssh_path)}"
      user        = "${var.user}"
      type        = "ssh"
    }

    destination = "kube-scheduler-key.pem"
    source      = "${var.certs_path}/kube-scheduler-key.pem"
  }

  provisioner "file" {
    connection {
      private_key = "${file(var.ssh_path)}"
      user        = "${var.user}"
      type        = "ssh"
    }

    destination = "service-account.pem"
    source      = "${var.certs_path}/service-account.pem"
  }

  provisioner "file" {
    connection {
      private_key = "${file(var.ssh_path)}"
      user        = "${var.user}"
      type        = "ssh"
    }

    destination = "service-account-key.pem"
    source      = "${var.certs_path}/service-account-key.pem"
  }

  provisioner "file" {
    connection {
      private_key = "${file(var.ssh_path)}"
      user        = "${var.user}"
      type        = "ssh"
    }

    destination = "start-controller.sh"
    source      = "${var.scripts_path}/start-controller.sh"
  }

  provisioner "file" {
    connection {
      private_key = "${file(var.ssh_path)}"
      user        = "${var.user}"
      type        = "ssh"
    }

    destination = "start-etcd.sh"
    source      = "${var.scripts_path}/start-etcd.sh"
  }

  provisioner "remote-exec" {
    connection {
      private_key = "${file(var.ssh_path)}"
      user        = "${var.user}"
      type        = "ssh"
    }

    inline = [
      "sleep 30",
      "sudo chmod +x add-ssh-keys.sh create-rbac.sh gen-admin-config.sh gen-api-server-certs.sh gen-controller-manager-config.sh gen-scheduler-config.sh install-controller.sh start-controller.sh start-etcd.sh",
      "./add-ssh-keys.sh",
      "./install-controller.sh",
      "./gen-api-server-certs.sh ${var.project} ${google_compute_address.k8s_staticip.address}",
      "./gen-controller-manager-config.sh",
      "./gen-scheduler-config.sh",
      "./gen-admin-config.sh",
      "./start-etcd.sh ${var.project}",
      "./start-controller.sh ${var.project}",
      "./create-rbac.sh",
    ]
  }

  service_account {
    scopes = ["compute-rw", "storage-ro", "service-management", "service-control", "logging-write", "monitoring"]
  }

  tags = ["controller"]
  zone = "${var.region}-${lookup(var.zone_map, count.index)}"
}

resource "google_compute_instance" "k8s_worker" {
  boot_disk {
    auto_delete = true

    initialize_params {
      image = "${var.worker_image}"
      size  = "${var.worker_size}"
    }
  }

  can_ip_forward = true
  count          = "${var.worker_count}"
  machine_type   = "${var.worker_type}"
  name           = "k8s-worker${count.index}"

  network_interface {
    access_config = {}
    subnetwork    = "${google_compute_subnetwork.k8s_subnet.name}"
  }

  metadata {
    creator  = "${var.user}"
    pod-cidr = "10.200.${count.index}.0/24"
  }

  provisioner "file" {
    connection {
      private_key = "${file(var.ssh_path)}"
      user        = "${var.user}"
      type        = "ssh"
    }

    destination = "add-ssh-keys.sh"
    source      = "${var.scripts_path}/add-ssh-keys.sh"
  }

  provisioner "file" {
    connection {
      private_key = "${file(var.ssh_path)}"
      user        = "${var.user}"
      type        = "ssh"
    }

    destination = "ca.pem"
    source      = "${var.certs_path}/ca.pem"
  }

  provisioner "file" {
    connection {
      private_key = "${file(var.ssh_path)}"
      user        = "${var.user}"
      type        = "ssh"
    }

    destination = "ca-key.pem"
    source      = "${var.certs_path}/ca-key.pem"
  }

  provisioner "file" {
    connection {
      private_key = "${file(var.ssh_path)}"
      user        = "${var.user}"
      type        = "ssh"
    }

    destination = "ca-config.json"
    source      = "${var.certs_path}/ca-config.json"
  }

  provisioner "file" {
    connection {
      private_key = "${file(var.ssh_path)}"
      user        = "${var.user}"
      type        = "ssh"
    }

    destination = "gen-client-certs.sh"
    source      = "${var.scripts_path}/gen-client-certs.sh"
  }

  provisioner "file" {
    connection {
      private_key = "${file(var.ssh_path)}"
      user        = "${var.user}"
      type        = "ssh"
    }

    destination = "gen-kubelet-config.sh"
    source      = "${var.scripts_path}/gen-kubelet-config.sh"
  }

  provisioner "file" {
    connection {
      private_key = "${file(var.ssh_path)}"
      user        = "${var.user}"
      type        = "ssh"
    }

    destination = "gen-proxy-config.sh"
    source      = "${var.scripts_path}/gen-proxy-config.sh"
  }

  provisioner "file" {
    connection {
      private_key = "${file(var.ssh_path)}"
      user        = "${var.user}"
      type        = "ssh"
    }

    destination = "kube-proxy.pem"
    source      = "${var.certs_path}/kube-proxy.pem"
  }

  provisioner "file" {
    connection {
      private_key = "${file(var.ssh_path)}"
      user        = "${var.user}"
      type        = "ssh"
    }

    destination = "kube-proxy-key.pem"
    source      = "${var.certs_path}/kube-proxy-key.pem"
  }

  provisioner "file" {
    connection {
      private_key = "${file(var.ssh_path)}"
      user        = "${var.user}"
      type        = "ssh"
    }

    destination = "install-worker.sh"
    source      = "${var.scripts_path}/install-worker.sh"
  }

  provisioner "file" {
    connection {
      private_key = "${file(var.ssh_path)}"
      user        = "${var.user}"
      type        = "ssh"
    }

    destination = "k8s-worker${count.index}-csr.json"
    source      = "${var.certs_path}/k8s-worker${count.index}-csr.json"
  }

  service_account {
    scopes = ["compute-rw", "storage-ro", "service-management", "service-control", "logging-write", "monitoring"]
  }

  provisioner "file" {
    connection {
      private_key = "${file(var.ssh_path)}"
      user        = "${var.user}"
      type        = "ssh"
    }

    destination = "start-worker.sh"
    source      = "${var.scripts_path}/start-worker.sh"
  }

  provisioner "remote-exec" {
    connection {
      private_key = "${file(var.ssh_path)}"
      user        = "${var.user}"
      type        = "ssh"
    }

    inline = [
      "sleep 30",
      "sudo chmod +x add-ssh-keys.sh gen-client-certs.sh gen-kubelet-config.sh gen-proxy-config.sh install-worker.sh start-worker.sh",
      "./add-ssh-keys.sh",
      "./install-worker.sh",
      "./gen-client-certs.sh",
      "./gen-kubelet-config.sh ${google_compute_address.k8s_staticip.address}",
      "./gen-proxy-config.sh ${google_compute_address.k8s_staticip.address}",
      "./start-worker.sh",
    ]
  }

  tags = ["worker"]
  zone = "${var.region}-${lookup(var.zone_map, count.index)}"
}

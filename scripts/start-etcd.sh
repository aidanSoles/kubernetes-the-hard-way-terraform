#!/bin/bash

{
echo && echo "$0: " && echo

PROJ_NAME=$1
CONTROLLER0_IP=$(dig +short k8s-controller0.us-west1-a.c."$PROJ_NAME".internal)
CONTROLLER1_IP=$(dig +short k8s-controller1.us-west1-b.c."$PROJ_NAME".internal)
CONTROLLER2_IP=$(dig +short k8s-controller2.us-west1-c.c."$PROJ_NAME".internal)
ETCD_NAME=$(hostname -s)
INTERNAL_IP=$(curl -s "http://metadata/computeMetadata/v1/instance/network-interfaces/0/ip" -H "Metadata-Flavor: Google")

sudo mkdir -p /etc/etcd /var/lib/etcd
sudo cp ca.pem kubernetes-key.pem kubernetes.pem /etc/etcd/

cat <<EOF | sudo tee /etc/systemd/system/etcd.service
[Unit]
Description=etcd
Documentation=https://github.com/coreos

[Service]
ExecStart=/usr/local/bin/etcd \\
  --name ${ETCD_NAME} \\
  --cert-file=/etc/etcd/kubernetes.pem \\
  --key-file=/etc/etcd/kubernetes-key.pem \\
  --peer-cert-file=/etc/etcd/kubernetes.pem \\
  --peer-key-file=/etc/etcd/kubernetes-key.pem \\
  --trusted-ca-file=/etc/etcd/ca.pem \\
  --peer-trusted-ca-file=/etc/etcd/ca.pem \\
  --peer-client-cert-auth \\
  --client-cert-auth \\
  --initial-advertise-peer-urls https://${INTERNAL_IP}:2380 \\
  --listen-peer-urls https://${INTERNAL_IP}:2380 \\
  --listen-client-urls https://${INTERNAL_IP}:2379,https://127.0.0.1:2379 \\
  --advertise-client-urls https://${INTERNAL_IP}:2379 \\
  --initial-cluster-token etcd-cluster-0 \\
  --initial-cluster k8s-controller0=https://${CONTROLLER0_IP}:2380,k8s-controller1=https://${CONTROLLER1_IP}:2380,k8s-controller2=https://${CONTROLLER2_IP}:2380 \\
  --initial-cluster-state new \\
  --data-dir=/var/lib/etcd
Restart=on-failure
RestartSec=5

[Install]
WantedBy=multi-user.target
EOF

sudo systemctl daemon-reload
sudo systemctl enable etcd
sudo systemctl start etcd

# Verify that everything is working
sudo ETCDCTL_API=3 etcdctl member list \
	--endpoints=https://127.0.0.1:2379 \
	--cacert=/etc/etcd/ca.pem \
	--cert=/etc/etcd/kubernetes.pem \
	--key=/etc/etcd/kubernetes-key.pem
} >> cloudinit.log

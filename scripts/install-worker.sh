#!/bin/bash

{
echo && echo "$0: " && echo

# Install cfssl and cfssljson
wget -q --https-only --timestamping \
    https://pkg.cfssl.org/R1.2/cfssl_linux-amd64 \
    https://pkg.cfssl.org/R1.2/cfssljson_linux-amd64

chmod +x cfssl_linux-amd64 cfssljson_linux-amd64
sudo mv cfssl_linux-amd64 /usr/local/bin/cfssl
sudo mv cfssljson_linux-amd64 /usr/local/bin/cfssljson

# Install kubectl
sudo apt-get update && sudo apt-get install -y apt-transport-https
curl -s https://packages.cloud.google.com/apt/doc/apt-key.gpg | sudo apt-key add -
sudo touch /etc/apt/sources.list.d/kubernetes.list 
echo "deb http://apt.kubernetes.io/ kubernetes-xenial main" | sudo tee -a /etc/apt/sources.list.d/kubernetes.list
sudo apt-get update
sudo apt-get install -y kubectl

# Install OS Dependencies
sudo apt-get update
sudo apt-get -y install socat conntrack ipset


# Install/Configure Worker Dependencies
wget -q --show-progress --https-only --timestamping \
    https://github.com/kubernetes-incubator/cri-tools/releases/download/v1.0.0-beta.0/crictl-v1.0.0-beta.0-linux-amd64.tar.gz \
    https://storage.googleapis.com/kubernetes-the-hard-way/runsc \
    https://github.com/opencontainers/runc/releases/download/v1.0.0-rc5/runc.amd64 \
    https://github.com/containernetworking/plugins/releases/download/v0.6.0/cni-plugins-amd64-v0.6.0.tgz \
    https://github.com/containerd/containerd/releases/download/v1.1.0/containerd-1.1.0.linux-amd64.tar.gz \
    https://storage.googleapis.com/kubernetes-release/release/v1.10.2/bin/linux/amd64/kubectl \
    https://storage.googleapis.com/kubernetes-release/release/v1.10.2/bin/linux/amd64/kube-proxy \
    https://storage.googleapis.com/kubernetes-release/release/v1.10.2/bin/linux/amd64/kubelet

sudo mkdir -p \
    /etc/cni/net.d \
    /opt/cni/bin \
    /var/lib/kubelet \
    /var/lib/kube-proxy \
    /var/lib/kubernetes \
    /var/run/kubernetes
  
chmod +x kubectl kube-proxy kubelet runc.amd64 runsc
    sudo mv runc.amd64 runc
    sudo mv kubectl kube-proxy kubelet runc runsc /usr/local/bin/
    sudo tar -xvf crictl-v1.0.0-beta.0-linux-amd64.tar.gz -C /usr/local/bin/
    sudo tar -xvf cni-plugins-amd64-v0.6.0.tgz -C /opt/cni/bin/
    sudo tar -xvf containerd-1.1.0.linux-amd64.tar.gz -C /
} >> cloudinit.log

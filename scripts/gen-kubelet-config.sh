#!/bin/bash

{
echo && echo "$0: " && echo

KUBERNETES_PUBLIC_ADDRESS=$1 # Static IP address provisioned in networking.tf
NODE_NAME=$(curl -s "http://metadata/computeMetadata/v1/instance/hostname" -H "Metadata-Flavor: Google" | cut -d. -f1)

echo "$KUBERNETES_PUBLIC_ADDRESS"
echo "$NODE_NAME"

kubectl config set-cluster k8s-the-hard-way \
    --certificate-authority=ca.pem \
    --embed-certs=true \
    --server=https://"${KUBERNETES_PUBLIC_ADDRESS}":6443 \
    --kubeconfig="${NODE_NAME}".kubeconfig

kubectl config set-credentials system:node:"${NODE_NAME}" \
    --client-certificate="${NODE_NAME}".pem \
    --client-key="${NODE_NAME}"-key.pem \
    --embed-certs=true \
    --kubeconfig="${NODE_NAME}".kubeconfig

kubectl config set-context default \
    --cluster=k8s-the-hard-way \
    --user=system:node:"${NODE_NAME}" \
    --kubeconfig="${NODE_NAME}".kubeconfig

kubectl config use-context default --kubeconfig="${NODE_NAME}".kubeconfig
} >> cloudinit.log

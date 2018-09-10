#!/bin/bash

{
echo && echo "$0: " && echo

KUBERNETES_PUBLIC_ADDRESS=$1 # Static IP address provisioned in networking.tf

kubectl config set-cluster k8s-the-hard-way \
    --certificate-authority=ca.pem \
    --embed-certs=true \
    --server=https://"${KUBERNETES_PUBLIC_ADDRESS}":6443 \
    --kubeconfig=kube-proxy.kubeconfig
    
kubectl config set-credentials system:kube-proxy \
    --client-certificate=kube-proxy.pem \
    --client-key=kube-proxy-key.pem \
    --embed-certs=true \
    --kubeconfig=kube-proxy.kubeconfig
    
kubectl config set-context default \
    --cluster=k8s-the-hard-way \
    --user=system:kube-proxy \
    --kubeconfig=kube-proxy.kubeconfig
    
kubectl config use-context default --kubeconfig=kube-proxy.kubeconfig
} >> cloudinit.log

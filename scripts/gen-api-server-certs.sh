#!/bin/bash

{
echo && echo "$0: " && echo

PROJ_NAME=$1
CONTROLLER0_IP=$(dig +short k8s-controller0.us-west1-a.c."$PROJ_NAME".internal)
CONTROLLER1_IP=$(dig +short k8s-controller1.us-west1-b.c."$PROJ_NAME".internal)
CONTROLLER2_IP=$(dig +short k8s-controller2.us-west1-c.c."$PROJ_NAME".internal)
KUBERNETES_PUBLIC_ADDRESS=$2

cfssl gencert \
  -ca=ca.pem \
  -ca-key=ca-key.pem \
  -config=ca-config.json \
  -hostname=10.32.0.1,"${CONTROLLER0_IP}","${CONTROLLER1_IP}","${CONTROLLER2_IP}","${KUBERNETES_PUBLIC_ADDRESS}",127.0.0.1,kubernetes.default \
  -profile=kubernetes \
  kubernetes-csr.json | cfssljson -bare kubernetes
} >> cloudinit.log

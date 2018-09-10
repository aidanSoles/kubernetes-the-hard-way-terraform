#!/bin/bash

{
echo && echo "$0: " && echo

EXTERNAL_IP=$(curl -s "http://metadata/computeMetadata/v1/instance/network-interfaces/0/access-configs/0/external-ip" -H "Metadata-Flavor: Google")
echo "$EXTERNAL_IP"
NODE_NAME=$(curl -s "http://metadata/computeMetadata/v1/instance/hostname" -H "Metadata-Flavor: Google" | cut -d. -f1)
echo "$NODE_NAME"
INTERNAL_IP=$(curl -s "http://metadata/computeMetadata/v1/instance/network-interfaces/0/ip" -H "Metadata-Flavor: Google")
echo "$INTERNAL_IP"

cfssl gencert \
	-ca=ca.pem \
	-ca-key=ca-key.pem \
	-config=ca-config.json \
	-hostname="${NODE_NAME}","${EXTERNAL_IP}","${INTERNAL_IP}" \
	-profile=kubernetes \
	"${NODE_NAME}"-csr.json | cfssljson -bare "${NODE_NAME}"
} >> cloudinit.log

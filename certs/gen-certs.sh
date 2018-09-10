#!/bin/bash

check_prereqs () {
    declare -a req_progs=("cfssl" "cfssljson")

    for prog in "${req_progs[@]}"
    do
        if ! which "${prog}" > /dev/null 2>&1; then
            echo "${prog} not installed. Please install it then rerun this script."
            exit 1
        fi
    done
}

gen_admin_client_cert () {
	cfssl gencert \
	    -ca=ca.pem \
	    -ca-key=ca-key.pem \
	    -config=ca-config.json \
	    -profile=kubernetes \
	    admin-csr.json | cfssljson -bare admin
}

gen_controller_manager_cert () {
	cfssl gencert \
	    -ca=ca.pem \
	    -ca-key=ca-key.pem \
	    -config=ca-config.json \
	    -profile=kubernetes \
	    kube-controller-manager-csr.json | cfssljson -bare kube-controller-manager
}

gen_kubernetes_api_cert () {
	cfssl gencert \
	    -ca=ca.pem \
	    -ca-key=ca-key.pem \
	    -config=ca-config.json \
	    -hostname=10.32.0.1,10.240.0.10,10.240.0.11,10.240.0.12,"${KUBERNETES_PUBLIC_ADDRESS}",127.0.0.1,kubernetes.default \
	    -profile=kubernetes \
	    kubernetes-csr.json | cfssljson -bare kubernetes
}

gen_kube_proxy_client_cert () {
	cfssl gencert \
	    -ca=ca.pem \
	    -ca-key=ca-key.pem \
	    -config=ca-config.json \
	    -profile=kubernetes \
	    kube-proxy-csr.json | cfssljson -bare kube-proxy
}

gen_scheduler_client_cert () {
	cfssl gencert \
	    -ca=ca.pem \
	    -ca-key=ca-key.pem \
	    -config=ca-config.json \
	    -profile=kubernetes \
	    kube-scheduler-csr.json | cfssljson -bare kube-scheduler
}

gen_service_account_kp () {
	cfssl gencert \
		-ca=ca.pem \
		-ca-key=ca-key.pem \
		-config=ca-config.json \
		-profile=kubernetes \
		service-account-csr.json | cfssljson -bare service-account
}

check_prereqs
gen_admin_client_cert
gen_controller_manager_cert
gen_kube_proxy_client_cert
gen_scheduler_client_cert
gen_kubernetes_api_cert
gen_service_account_kp

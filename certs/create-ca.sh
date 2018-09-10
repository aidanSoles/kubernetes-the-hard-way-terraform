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

gen_ca_cert () {
    cfssl gencert -initca ca-csr.json | cfssljson -bare ca
}

check_prereqs
gen_ca_cert

#!/bin/bash

set -x

sleep 30

# TODO: If you want to add other peoples' public SSH keys to allow them to SSH onto your machines (see the "Motivation" sections of the README), then make an uncommented line below that looks like the following (but uncommented):
# GITHUB_ACCOUNTS=('aidanSoles' 'defunkt' 'torvalds' 'kelseyhightower')
GITHUB_ACCOUNTS=()

# Shouldn't take longer than 10 sec to connect
# and 2 min for the total operation
CURL_FLAGS="-L --connect-timeout 10 --max-time 120"

add_github_pub_keys(){
  for account in "${GITHUB_ACCOUNTS[@]}";do
    echo "# Keys for ${account}" >> ~/.ssh/authorized_keys
    curl $CURL_FLAGS "https://github.com/${account}.keys" >> ~/.ssh/authorized_keys
  done
}

add_github_pub_keys

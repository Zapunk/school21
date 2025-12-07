#!/bin/bash

set -e

sudo apt update
sudo apt install curl unzip -y

VERSION="1.21.0"

curl -sSL -o /tmp/consul.zip "https://releases.hashicorp.com/consul/${VERSION}/consul_${VERSION}_linux_amd64.zip"
sudo unzip /tmp/consul.zip -d /usr/local/bin/
sudo chmod +x /usr/local/bin/consul
sudo rm -f /tmp/consul.zip
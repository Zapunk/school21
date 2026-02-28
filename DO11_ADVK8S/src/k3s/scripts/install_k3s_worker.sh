#!/bin/bash

set -e

MASTER_IP="192.168.56.10"

apt-get update -y
echo "Установка curl"
apt-get install -y curl
echo "Ждем токен...."
while [ ! -f /vagrant/token ]; do
  sleep 5
done
echo 
NODE_TOKEN=$(cat /vagrant/token)
echo "Подключаемся к Мастеру"
curl -sfL https://get.k3s.io | \
K3S_URL=https://$MASTER_IP:6443 \
K3S_TOKEN=$NODE_TOKEN \
INSTALL_K3S_EXEC="--node-ip=$(hostname -I | awk '{print $2}')" \
sh -

echo "Воркер подключен успешно"
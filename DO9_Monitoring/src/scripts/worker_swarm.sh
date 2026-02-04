#!/bin/bash

for i in {1..60}; do
  if [ -f /vagrant/token ]; then
    break
  fi
  echo "ждем токен... ($i)"
  sleep 2
done

if [ ! -f /vagrant/token ]; then
  echo "токен не создался"
  exit 1
fi

token=$(cat /vagrant/token)
docker swarm join --token "$token" 192.168.56.10:2377
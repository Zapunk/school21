#!/bin/bash
if docker info | grep -q "Swarm: active"; then
  docker swarm leave --force
fi
docker swarm init --advertise-addr 192.168.56.10
docker swarm join-token -q worker > /vagrant/token
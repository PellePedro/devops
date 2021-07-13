#!/bin/bash

PWD=kubeadmin

VMS=( 
172.16.16.100
172.16.16.101
172.16.16.102
)

for vm in "${VMS[@]}"; do
  echo "${vm}"
  sshpass -p $PWD scp -o UserKnownHostsFile=/dev/null -o StrictHostKeyChecking=no \
  config.toml root@"${vm}":/etc/containerd/config.toml

  sshpass -p $PWD ssh -o UserKnownHostsFile=/dev/null -o StrictHostKeyChecking=no \
  root@${vm} systemctl restart containerd
done


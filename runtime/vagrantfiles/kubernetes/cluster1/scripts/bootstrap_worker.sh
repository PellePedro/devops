#!/bin/bash

cat /etc/hosts

echo "[TASK 1] Join node to Kubernetes Cluster [${MASTER_IP}]"
apt install -qq -y sshpass >/dev/null 2>&1
sshpass -p "kubeadmin" scp -o UserKnownHostsFile=/dev/null -o StrictHostKeyChecking=no ${MASTER_IP}:/joincluster.sh /joincluster.sh

#sshpass -p "kubeadmin" scp -o UserKnownHostsFile=/dev/null -o StrictHostKeyChecking=no ${MASTER_IP}:/joincluster.sh /joincluster.sh 2>/dev/null
bash /joincluster.sh
#bash /joincluster.sh >/dev/null 2>&1

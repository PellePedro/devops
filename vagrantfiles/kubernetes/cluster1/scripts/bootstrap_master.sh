#!/bin/bash

echo "[TASK 2] Initialize Kubernetes Cluster on master ${MASTER_IP} ${POD_NETWORK_CIDR}"

echo "[TASK 1] Pull required containers"
kubeadm config images pull >/dev/null 2>&1

echo "[TASK 2] Initialize Kubernetes Cluster on master ${MASTER_IP} ${POD_NETWORK_CIDR}"
kubeadm init --apiserver-advertise-address=${MASTER_IP} --pod-network-cidr="${POD_NETWORK_CIDR}" >> /root/kubeinit.log 2>/dev/null

echo "[TASK 3] Deploy Calico network"
kubectl --kubeconfig=/etc/kubernetes/admin.conf create -f https://docs.projectcalico.org/v3.16/manifests/calico.yaml >/dev/null 2>&1

kubeadm token create --print-join-command > /joincluster.sh 2>/dev/null

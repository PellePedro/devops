#/bin/bash

master=$1
mkdir -p ~/.kube

lxc file pull "${master}"/etc/kubernetes/admin.conf ~/.kube/config

lxc list ${master} -c n4

echo "------------------------------------------------------------"
echo "Define remote ssh tunnel with command"
echo "ssh -fNL 6443:<master eth0>:6443 <jumphost>
echo "------------------------------------------------------------"



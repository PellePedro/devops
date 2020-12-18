#/bin/bash

echo "Copy Kubeconfig"
sshpass -p "kubeadmin" scp \
        -o UserKnownHostsFile=/dev/null \
        -o StrictHostKeyChecking=no \
        root@172.16.16.100:/etc/kubernetes/admin.conf ~/.kube/config


echo "Deploy Registry Secret"
kubectl create secret generic regcred \
    --from-file=.dockerconfigjson=$(pwd)/registry-auth/pull-secret.json \
    --type=kubernetes.io/dockerconfigjson

echo "Deploy busybox"
kubectl apply -f yaml/busybox.yaml

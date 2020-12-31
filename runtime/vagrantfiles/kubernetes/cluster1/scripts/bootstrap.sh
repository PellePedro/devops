#!/bin/bash

## !IMPORTANT ##
#
## This script is tested only in the generic/ubuntu2004 Vagrant box
## If you use a different version of Ubuntu or a different Ubuntu Vagrant box test this again
#

echo "[TASK 1] Disable kvp.daemon.service"

systemctl disable hv-kvp-daemon.service
systemctl stop hv-kvp-daemon.service

cat <<-EOF > /etc/systemd/system/multi-user.target.wants/hv-kvp-daemon.service
[Unit]
Description=Hyper-V KVP Protocol Daemon
ConditionVirtualization=microsoft
ConditionPathExists=/dev/vmbus/hv_kvp
DefaultDependencies=no
BindsTo=sys-devices-virtual-misc-vmbus\x21hv_kvp.device
After=systemd-remount-fs.service
Before=shutdown.target cloud-init-local.service walinuxagent.service
Conflicts=shutdown.target
RequiresMountsFor=/var/lib/hyperv

[Service]
ExecStart=/usr/sbin/hv_kvp_daemon -n

[Install]
WantedBy=multi-user.target
EOF


echo "[TASK 2] Disable and turn off SWAP"
sed -i '/swap/d' /etc/fstab
swapoff -a

echo "[TASK 3] Stop and Disable firewall"
systemctl disable --now ufw >/dev/null 2>&1

echo "[TASK 4] Enable and Load Kernel modules"
cat >>/etc/modules-load.d/containerd.conf<<EOF
overlay
br_netfilter
EOF
modprobe overlay
modprobe br_netfilter

echo "[TASK 5] Add Kernel settings"
cat >>/etc/sysctl.d/kubernetes.conf<<EOF
net.bridge.bridge-nf-call-ip6tables = 1
net.bridge.bridge-nf-call-iptables  = 1
net.ipv4.ip_forward                 = 1
EOF
sysctl --system >/dev/null 2>&1

echo "[TASK 6] Install Container Runtime"
apt update -qq >/dev/null 2>&1

apt install -qq -y containerd apt-transport-https >/dev/null 2>&1
mkdir /etc/containerd
containerd config default > /etc/containerd/config.toml
systemctl restart containerd
systemctl enable containerd >/dev/null 2>&1

echo "[TASK 7] Add apt repo for kubernetes"
curl -s https://packages.cloud.google.com/apt/doc/apt-key.gpg | apt-key add - >/dev/null 2>&1
apt-add-repository 'deb http://apt.kubernetes.io/ kubernetes-xenial main' >/dev/null 2>&1

echo "[TASK 8] Install Kubernetes components (kubeadm, kubelet and kubectl)"
apt install -qq -y kubeadm=1.20.0-00 kubelet=1.20.0-00 kubectl=1.20.0-00 >/dev/null 2>&1

echo "[TASK 9] Enable ssh password authentication"
sed -i 's/^PasswordAuthentication .*/PasswordAuthentication yes/' /etc/ssh/sshd_config
echo 'PermitRootLogin yes' >> /etc/ssh/sshd_config
systemctl reload sshd

echo "[TASK 10] Set root password"
echo -e "kubeadmin\nkubeadmin" | passwd root >/dev/null 2>&1
echo "export TERM=xterm" >> /etc/bash.bashrc


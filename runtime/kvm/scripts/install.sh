#!/bin/bash

sudo bash
apt update
uname="$1" || username="$(whoami)"

export DEBIAN_FRONTEND=noninteractive
# installing libvirt
apt install qemu-system libvirt-clients libvirt-daemon-system
apt install virt-manager
adduser ${username} libvirt
cat >> ~/.bashrc<<EOF
export LIBVIRT_DEFAULT_URI='qemu:///system'
EOF
source ~/.bashrc

#installing vagrant
apt install vagrant-libvirt libvirt-daemon-system

#installing ansible
apt install ansible

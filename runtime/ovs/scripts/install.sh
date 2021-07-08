#!/bin/bash

export DEBIAN_FRONTEND=noninteractive
apt-get update -m
apt-get install -y openvswitch-switch openvswitch-vtep
service openvswitch-switch restart
service openvswitch-switch status


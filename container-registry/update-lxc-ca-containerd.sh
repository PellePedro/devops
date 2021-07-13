#!/bin/bash

# https://github.com/lxc/lxc-ci/blob/master/bin/test-lxd-snapd
for container in $(lxc list --fast | tail -n+3 | grep "^| " | cut -d' ' -f2); do
  echo "${container}"
  lxc file push config.toml "${container}"/etc/containerd/config.toml
  lxc exec "${container}" -- systemctl restart containerd
done


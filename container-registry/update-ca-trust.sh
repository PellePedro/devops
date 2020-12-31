#!/bin/bash

# https://github.com/lxc/lxc-ci/blob/master/bin/test-lxd-snapd
for container in $(lxc list --fast | tail -n+3 | grep "^| " | cut -d' ' -f2); do
  lxc file push auth/registry.crt "${container}"/etc/ssl/certs/
  lxc exec "${container}" -- update-ca-certificates
done


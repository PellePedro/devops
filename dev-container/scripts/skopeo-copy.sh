#!/bin/bash

SRC_REG=projects.registry.vmware.com/antrea
DST_REG=docker.io/pellepedro
images=(
  antrea-ubuntu:latest
)

for image in "${images[@]}"; do
   skopeo copy \
     docker://"${SRC_REG}/${image}" \
     docker://"${DST_REG}/${image}"
done

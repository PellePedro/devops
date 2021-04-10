#!/bin/bash
set -ex

################################################################################
#
# Base Container Buildfile
#
#################################################################################

OS=$(awk -F= '/^ID=/ {print $2}' /etc/os-release)
BUILD=build

# Removing Build directory
rm -rf ${BUILD} || mkdir -p ${BUILD}

# Build nvim nightly in container
DOCKER_BUILDKIT=1 docker build --target=artifact --output type=local,dest=$(pwd)/${BUILD}/ -f Dockerfile.nvim  .

# Install/update os distro packages
./scripts/install-${OS}-packages.sh

# Install go
./scripts/install-go-linux.sh

# Install java jdk
#cat app-releases/install-jdk-linux | bash


################################################################################
# End
################################################################################

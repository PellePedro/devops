#!/bin/bash
set -ex

################################################################################
#
# Base Container Buildfile
#
#################################################################################

OS=$(awk -F= '/^ID=/ {print $2}' /etc/os-release)

# Install/update os distro packages
./scripts/install-${OS}-packages.sh

# Install go
./scripts/install-go-linux.sh

# Install java jdk
#cat app-releases/install-jdk-linux | bash

# Install dev
./scripts/install-dev-tools.sh

################################################################################
# End
################################################################################

#!/bin/bash
set -ex

################################################################################
#
# Base Container Buildfile
#
#################################################################################

OS=$(awk -F= '/^ID=/ {print $2}' /etc/os-release)

# Install/update os distro packages
cat os-packages/install-${OS}-packages | bash

# Install go
cat app-releases/install-go-linux | bash

# Install java jdk
cat app-releases/install-jdk-linux | bash


# Install dev
cat app-releases/install-dev-tools | bash

################################################################################
# End
################################################################################

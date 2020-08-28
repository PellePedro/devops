#!/bin/bash
# podman run --name python-dev -dt --userns keep-id -v $PROJECT_PATH:/home/pythonsvc/:Z localhost/devtool:latest
set -ex


################################################################################
#
# Buildfile to install devtools on host
#
#################################################################################

# Install RUST
cat app-releases/install-rust-linux | bash

./dotfiles/bootstrap.sh

################################################################################
# End
################################################################################

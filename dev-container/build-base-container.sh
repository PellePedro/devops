#!/bin/bash
# podman run --name python-dev -dt --userns keep-id -v $PROJECT_PATH:/home/pythonsvc/:Z localhost/devtool:latest
set -ex

IMAGE=$1
OS=$2

################################################################################
#
# Base Container Buildfile
#
#################################################################################

#OS=$(awk -F= '/^ID=/ {print $2}' /etc/os-release)

if [[ ! $OS =~ (fedora) && ! $OS =~ (ubuntu) ]]; then
    echo "The supported base images are ubuntu and fedora"
    exit
fi

runtime_container=$(buildah from --name ${IMAGE} ${OS})
runtime_mount=$(buildah mount $runtime_container)

# Install/update os distro packages
cat os-packages/install-${OS}-packages | buildah run ${IMAGE} -- sh

# Install go
cat app-releases/install-go-linux | buildah run ${IMAGE} -- bash

# Install java jdk
cat app-releases/install-jdk-linux | buildah run ${IMAGE} -- bash

# ==================== Build Neovim ==========================================

nvim_build_image=ubuntu:20.04
nvim_build_container=$(buildah from ${nvim_build_image} )
nvim_build_mount=$(buildah mount ${nvim_build_container} )

cat os-packages/nvim-build-env | buildah run ${nvim_build_container} -- bash
buildah config --workingdir /neovim ${nvim_build_container}

cat <<-EOF | buildah run ${nvim_build_container} -- bash
	git tag -d nightly
	git tag nightly
	make CMAKE_BUILD_TYPE=RelWithDebInfo
	make CMAKE_INSTALL_PREFIX=/neovim/install install
EOF
rsync -a ${nvim_build_mount}/neovim/install/  ${runtime_mount}/usr/local

# =============================================================================

# ==================== Install Dev Tools ======================================
cat app-releases/install-dev-tools | buildah run ${IMAGE} -- bash

export GOROOT=/usr/local/go
export JDK_HOME=/opt/jdk
buildah config \
	--env JDK_HOME=$JDK_HOME \
	--env GOROOT=$GOROOT     \
	--env PATH=$PATH:${JDK_HOME}/bin:${GOROOT}/bin \
	${IMAGE}
# =============================================================================

#buildah unmount ${nvim_build_mount}
#buildah unmount ${runtime_mount}
buildah commit --squash --rm $IMAGE $IMAGE
buildah commit --squash --rm ${nvim_build_container} nvim-builder

################################################################################
# End
################################################################################

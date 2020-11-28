#!/bin/bash

set -ex

# =============================================================================
#
# Buildfile to build neovim head from master
#
# =============================================================================

BASE_IMAGE=ubuntu:20.04
NVIM_BUILD_IMAGE=nvim-dev-build

build_container=$(buildah from --name ${NVIM_BUILD_IMAGE} ${BASE_IMAGE} )
build_mount=$(buildah mount $build_container)

cat os-packages/nvim-build-env | buildah run ${build_container} -- bash
buildah config --workingdir /neovim ${build_container}

cat <<-EOF | buildah run ${build_container} -- bash
	git tag -d nightly
	git tag nightly
	make CMAKE_BUILD_TYPE=RelWithDebInfo
	make CMAKE_INSTALL_PREFIX=/neovim/install install
	cd install && tar cvf neovim.tar bin lib share
EOF

cp -R $build_mount/neovim/install/neovim.tar .

buildah unmount $build_container
buildah commit --squash --rm ${build_container} ${build_container}

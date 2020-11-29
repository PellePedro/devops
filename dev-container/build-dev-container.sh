#!/bin/bash
# podman run --name python-dev -dt --userns keep-id -v $PROJECT_PATH:/home/pythonsvc/:Z localhost/devtool:latest
set -ex

BASE=$1
IMAGE=$2

################################################################################
#
# Dev Container Buildfile
#
#################################################################################

runtime_container=$(buildah from --name ${IMAGE} ${BASE})
runtime_mount=$(buildah mount $runtime_container)

##################
# Setup Local User
#################

OS=$(awk -F= '/^ID=/ {print $2}' /etc/os-release)

username=devops
userid=${SUDO_UID:=1000}
groupid=${SUDO_GID:=1000}

groupname=$username
home=/home/$username

cat <<-EOF | buildah run ${IMAGE} -- sh
	groupadd -g $groupid $username
	useradd -u $userid --create-home --gid $username $username
	usermod -a -G sudo $username
	echo "$username  ALL=(ALL)  NOPASSWD:ALL" > /etc/sudoers.d/devops
EOF

buildah config \
	--user $username:$username \
	--workingdir /home/${username} \
	--env TMUX="tmux-osc52" \
	${IMAGE}

# RUST
cat app-releases/install-rust-linux | buildah run ${IMAGE} -- bash

buildah copy ${IMAGE} $(pwd)/dotfiles $home/.dotfiles
buildah run  ${IMAGE}  $home/.dotfiles/bootstrap.sh

## Kubernetes client codegen
K8S_BRANCH="release-1.19"
GIT_CODEGENERATOR="https://github.com/kubernetes/code-generator.git"
CODEGENERATOR_DIR=/opt/code-generator

build_container=$(buildah from golang:latest)
build_mount=$(buildah mount $build_container)

buildah run $build_container git clone --branch $K8S_BRANCH $GIT_CODEGENERATOR $CODEGENERATOR_DIR
buildah config --workingdir $CODEGENERATOR_DIR $build_container
buildah run $build_container go install ./cmd/{defaulter-gen,conversion-gen,client-gen,lister-gen,informer-gen,deepcopy-gen,openapi-gen}

rsync -a $build_mount/go/bin/* $runtime_mount/home/${username}/bin
# Clean up
buildah unmount $build_container
buildah unmount $runtime_container
buildah rm $build_container


buildah config --entrypoint /bin/zsh ${IMAGE}

buildah commit --squash --rm $IMAGE $IMAGE

################################################################################
# End
################################################################################

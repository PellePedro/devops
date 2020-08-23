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

buildah from --name ${IMAGE} ${BASE}


##################
# Setup Local User
#################

OS=$(awk -F= '/^ID=/ {print $2}' /etc/os-release)

userid=1000
groupid=1000
username=devops
groupname=$username
home=/home/$username

cat <<-EOF | buildah run ${IMAGE} -- sh
	groupadd -g $groupid $username
	useradd -u $userid --create-home --gid $username $username
	usermod -a -G sudo $username
	echo "$username\tALL=(ALL)\tNOPASSWD:ALL" > /etc/sudoers.d/devops
EOF

buildah config \
	--user $username:$username \
	--workingdir /home/${username} \
	${IMAGE}

buildah copy ${IMAGE} $(pwd)/dotfiles $home/.dotfiles
buildah run  ${IMAGE}  $home/.dotfiles/bootstrap.sh


buildah config --entrypoint /bin/zsh ${IMAGE}

buildah commit --squash --rm $IMAGE $IMAGE

################################################################################
# End
################################################################################

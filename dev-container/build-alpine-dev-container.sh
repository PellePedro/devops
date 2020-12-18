#!/bin/bash

set -ex

# =============================================================================
#
# Buildfile to build neovim head from master
#
# =============================================================================

BASE_IMAGE=$1
TARGET_IMAGE=$2

base_image=${BASE_IMAGE:-"alpine:edge"}
runtime_container_name=${TARGET_IMAGE:-"apline-dev"}
build_container_name=alpine-builder

runtime_container=$(buildah from --name ${runtime_container_name} ${base_image})
build_container=$(buildah from --name ${build_container_name} ${base_image})

runtime_mount=$(buildah mount $runtime_container)
build_mount=$(buildah mount $build_container)

# Runtime Container for neovim
cat <<-EOF | buildah run ${runtime_container} -- ash
	apk  add --update --no-cache \
	bash \
	git \
	curl \
	jq \
	unzip \
	tar \
	rsync \
	ripgrep \
	fzf \
	nmap \
    net-tools \
    libpcap \
    musl \
    arp-scan \
    darkhttpd \
    tcpdump \
    iperf3 \
    openssh \
    netcat-openbsd \
    bind-tools \
	nodejs \
	python3 \
	python3-dev \
	py3-pip \
	rust \
	ruby \
	ruby-dev \
	go \
	vifm \
	zsh \
	sudo
    apk add arp-scan --repository http://dl-cdn.alpinelinux.org/alpine/edge/testing
EOF

#buildah config --workingdir /neovim ${build_container}

# Build Container for neovim
cat <<-EOF | buildah run ${build_container} -- ash
	apk  add --no-cache \
	git \
	build-base \
	cmake \
	automake \
	autoconf \
	libtool \
	pkgconf \
	coreutils \
	curl \
	unzip \
	tar \
	rsync \
	gettext-tiny-dev
	git clone https://github.com/neovim/neovim.git && cd neovim && \
	git tag -d nightly && \
	git tag nightly && \
	make CMAKE_BUILD_TYPE=RelWithDebInfo && \
	make CMAKE_INSTALL_PREFIX=/neovim/install install
EOF

rsync -a ${build_mount}/neovim/install/  ${runtime_mount}/usr/local

username=devops
userid=${SUDO_UID:=1000}
groupid=${SUDO_GID:=1000}

groupname=$username
home=/home/$username

cat <<-EOF | buildah run ${runtime_container} -- ash
	addgroup -g $groupid $groupname && \
	adduser -D -u $userid -h /home/$username -G $groupname $username && \
	mkdir -p /etc/sudoers.d
	echo "$username  ALL=(ALL)  NOPASSWD:ALL" > /etc/sudoers.d/$username && \
	chmod 0440 /etc/sudoers.d/$username
EOF

buildah config \
	--user $username:$username \
	--workingdir /home/${username} \
	--env TMUX="tmux-osc52" \
	${runtime_container}

# RUST
#cat app-releases/install-rust-linux | buildah run ${IMAGE} -- bash

buildah copy ${runtime_container} $(pwd)/dotfiles $home/.dotfiles

cat <<-EOF | buildah run ${runtime_container} -- bash
	$home/.dotfiles/bootstrap.sh
	sudo chown -R devops:devops $home/.*
EOF

buildah unmount $runtime_container
buildah unmount $build_container
buildah commit --squash --rm ${runtime_container} ${runtime_container_name}


HOME := /home/pedro
PUBLIC_FEDORA_CONTAINER := docker.io/pellepedro/fedora-dev:latest
PUBLIC_UBUNTU_CONTAINER := docker.io/pellepedro/ubuntu-dev:latest
PUBLIC_ALPINE_CONTAINER := docker.io/pellepedro/alpine-dev:latest
FEDORA_BASE := fedora-base:latest
UBUNTU_BASE := ubuntu-base:latest
ALPINE_BASE := alpine:edge
UBUNTU_DEV := udev
FEDORA_DEV := fdev
ALPINE_DEV := adev
TAG := 0.1.0

.PHONY: help
help:	## - Show help message
	@printf "\033[32m\xE2\x9c\x93 usage: make [target]\n\n\033[0m"
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' Makefile | sort | awk 'BEGIN {FS = ":.*?## "}; {printf "\033[36m%-30s\033[0m %s\n", $$1, $$2}'

.PHONY: install-host
install-host:	## - Install requred packages and dev tools on host
	@printf "\033[32m\xE2\x9c\x93 Installing devtools on host \033[0m"
	@sudo ./install-host-packages.sh
	@ ./install-host-devtools.sh

.PHONY: build-fedora-dev-container
build-fedora-dev-container:	## - Build dev container based on Fedora
	@printf "\033[32m\xE2\x9c\x93 Building Fedora Dev Container ${FEDORA_DEV} \033[0m"
	@sudo buildah rm --all
	@sudo ./build-base-container.sh ${FEDORA_BASE} fedora
	@sudo ./build-dev-container.sh ${FEDORA_BASE} ${FEDORA_DEV}
	@sudo podman tag ${FEDORA_DEV} ${PUBLIC_FEDORA_CONTAINER}

.PHONY: build-alpine-dev-container
build-alpine-dev-container:	## - Build alpine development container
	@printf "\033[32m\xE2\x9c\x93 Building Alpine Development Container ${ALPINE_DEV} \033[0m"
	@sudo buildah rm --all
	@sudo ./build-alpine-dev-container.sh ${ALPINE_BASE} ${ALPINE_DEV}
	@sudo podman tag ${ALPINE_DEV} ${PUBLIC_ALPINE_CONTAINER}
.PHONY: build-alpine-dev-container

build-ubunntu-dev-container:	## - Build dev container based on Ubuntu
	@printf "\033[32m\xE2\x9c\x93 Building Ubuntu Dev Container ${UBUNTU_DEV} \033[0m"
	@sudo buildah rm --all
	@sudo ./build-base-container.sh ${UBUNTU_BASE} ubuntu
	@sudo ./build-dev-container.sh ${UBUNTU_BASE} ${UBUNTU_DEV}
	@sudo podman tag ${UBUNTU_DEV} ${PUBLIC_UBUNTU_CONTAINER}

.PHONY: Run-fedora-dev-container
run-fedora-dev-container:	## - Run devenv container
	@printf "\033[32m\xE2\x9c\x93 Running Fedora Development Container \033[0m\n"
	@scripts/run-fedora-dev.sh

.PHONY: Run-ubuntu-dev-container
run-ubuntu-dev-container:	## - Run devenv container
	@printf "\033[32m\xE2\x9c\x93 Running Ubuntu Development Container \033[0m\n"
	@scripts/run-ubuntu-dev.sh

.PHONY: run-alpine-dev-container
run-alpine-dev-container:	## - Run devenv container
	@printf "\033[32m\xE2\x9c\x93 Running Alpine Development Container \033[0m\n"
	@scripts/run-alpine-dev.sh

.PHONY: push
push:	## - Tag and push the udev container
	@printf "\033[32m\xE2\x9c\x93 Pushing Image ${PUBLIC_FEDORA_CONTAINER} \033[0m"
	@sudo buildah push ${FEDORA_DEV} "docker://${PUBLIC_FEDORA_CONTAINER}"
	@printf "\033[32m\xE2\x9c\x93 Pushing Image ${PUBLIC_ALPINE_CONTAINER} \033[0m"
	@sudo buildah push ${ALPINE_DEV} "docker://${PUBLIC_ALPINE_CONTAINER}"

.PHONY: list-sample-repo
list-sample-repo:	## - List sample repos to test LSP
	@printf "\033[32m\xE2\x9c\x93 git clone https://github.com/rakyll/hey.git \033[0m\n"
	@printf "\033[32m\xE2\x9c\x93 git clone https://github.com/kataras/iris.git \033[0m\n"
	@printf "\033[32m\xE2\x9c\x93 git clone https://github.com/tikv/grpc-rs.git \033[0m\n"

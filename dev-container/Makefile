
HOME := /home/pedro
PUBLIC_FEDORA_CONTAINER := docker.io/pellepedro/devenv:latest
PUBLIC_UBUNTU_CONTAINER := docker.io/pellepedro/udevenv:latest
FEDORA_BASE := fedora-base:latest
UBUNTU_BASE := ubuntu-base:latest
UBUNTU_DEV := udev
FEDORA_DEV := fdev
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

.PHONY: build-ubuntu-dev-container
build-ubunntu-dev-container:	## - Build dev container based on Ubuntu
	@printf "\033[32m\xE2\x9c\x93 Building Ubuntu Dev Container ${UBUNTU_DEV} \033[0m"
	@sudo buildah rm --all
	@sudo ./build-base-container.sh ${UBUNTU_BASE} ubuntu
	@sudo ./build-dev-container.sh ${UBUNTU_BASE} ${UBUNTU_DEV}
	@sudo podman tag ${UBUNTU_DEV} ${PUBLIC_UBUNTU_CONTAINER}

.PHONY: Run-fedora-dev-container	## - Run dev container based on Fedora
run-fedora-dev-container:	## - run devenv container
	@printf "\033[32m\xE2\x9c\x93 Running Development Container ${FEDORA_DEV} \033[0m\n"
	@sudo podman run -it \
		-v ${HOME}/.netrc:/home/devops/.netrc:z \
		-v ${HOME}/.ssh:/home/devops/.ssh:z \
		-v ${HOME}:/home/devops/host:rw \
		-v ${HOME}/go/pkg/mod:/home/devops/go/pkg/mod:z \
	${PUBLIC_FEDORA_CONTAINER} -name fdev

.PHONY: Run-ubuntu-dev-container	## - Run dev container based on Ubuntu
run-ubuntu-dev-container:	## - run devenv container
	@printf "\033[32m\xE2\x9c\x93 Running Development Container ${UBUNTU_DEV} \033[0m\n"
	@printf "\033[32m\xE2\x9c\x93 mounting $HOME to /home/devops/src \033[0m\n"
	@sudo podman run -it --security-opt label=disable -v ${HOME}:/home/devops/src   ${UBUNTU_DEV} -name udev

.PHONY: run-devenv	## - run devenv container
run-devenv:	## - run devenv container
	@printf "\033[32m\xE2\x9c\x93 Running Development Container ${FEDORA_DEV} \033[0m\n"
	@sudo podman run -itu root --privileged \
		-v ${HOME}/.netrc:/home/devops/.netrc:z \
		-v ${HOME}/.ssh:/home/devops/.ssh:z \
		-v ${HOME}:/home/devops/host:rw \
		-v ${HOME}/go/pkg/mod:/home/devops/go/pkg/mod:z \
	${PUBLIC_FEDORA_CONTAINER} -name fdev

.PHONY: push
push:	## - Tag and push the udev container
	@printf "\033[32m\xE2\x9c\x93 Pushing Image ${PUBLIC_FEDORA_CONTAINER} \033[0m"
	@sudo buildah push ${FEDORA_DEV} "docker://${PUBLIC_FEDORA_CONTAINER}"

.PHONY: list-sample-repo
list-sample-repo:	## - List sample repos to test LSP
	@printf "\033[32m\xE2\x9c\x93 git clone https://github.com/rakyll/hey.git \033[0m\n"
	@printf "\033[32m\xE2\x9c\x93 git clone https://github.com/kataras/iris.git \033[0m\n"
	@printf "\033[32m\xE2\x9c\x93 git clone https://github.com/tikv/grpc-rs.git \033[0m\n"

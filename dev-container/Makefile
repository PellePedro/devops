FEDORA_CONTAINER := docker.pkg.github.com/pellepedro/devops/fedora-dev:latest
UBUNTU_CONTAINER := docker.pkg.github.com/pellepedro/devops/ubuntu-dev:latest
ALPINE_CONTAINER := docker.pkg.github.com/pellepedro/devops/alpine-dev:latest

.PHONY: help
help:	## - Show help message
	@printf "\033[32m\xE2\x9c\x93 usage: make [target]\n\n\033[0m"
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' Makefile | sort | awk 'BEGIN {FS = ":.*?## "}; {printf "\033[36m%-30s\033[0m %s\n", $$1, $$2}'

.PHONY: install-host
install-host:	## - Install requred packages and nvim configyration
	@printf "\033[32m\xE2\x9c\x93 Installing devtools on host \033[0m"
	@sudo ./install-host.sh
	@rm -rf ~/.config/nvim ~/.local/share/nvim/
	@./dotfiles/bootstrap.sh

.PHONY: build-alpine-dev-container
build-alpine-dev-container:	## - Build alpine development container
	@printf "\033[32m\xE2\x9c\x93 Building Alpine Development Container ${ALPINE_CONTAINER} \033[0m"
	@DOCKER_BUILDKIT=1 docker build -f Dockerfile.alpine -t ${ALPINE_CONTAINER} .

.PHONY: build-fedora-dev-container
build-fedora-dev-container:	## - Build dev container based on Fedora
	@printf "\033[32m\xE2\x9c\x93 Building Fedora Dev Container ${FEDORA_CONTAINER} \033[0m"
	@DOCKER_BUILDKIT=1 docker build -f Dockerfile.fedora -t ${FEDORA_CONTAINER} .

build-ubuntu-dev-container:	## - Build dev container based on Ubuntu
	@printf "\033[32m\xE2\x9c\x93 Building Ubuntu Dev Container ${UBUNTU_CONTAINER} \033[0m"
	@DOCKER_BUILDKIT=1 docker build -f Dockerfile.ubuntu -t ${UBUNTU_CONTAINER} .

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

.PHONY: list-sample-repo
list-sample-repo:	## - List sample repos to test LSP
	@printf "\033[32m\xE2\x9c\x93 git clone https://github.com/rakyll/hey.git \033[0m\n"
	@printf "\033[32m\xE2\x9c\x93 git clone https://github.com/kataras/iris.git \033[0m\n"
	@printf "\033[32m\xE2\x9c\x93 git clone https://github.com/tikv/grpc-rs.git \033[0m\n"

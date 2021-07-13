UBUNTU_CONTAINER := docker.io/pellepedro/ubuntu-dev:latest
NVIM_CONTAINER := docker.io/pellepedro/nvim:latest

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

build-dev-container:	## - Build dev container based on Ubuntu
	@printf "\033[32m\xE2\x9c\x93 Building Ubuntu Dev Container ${UBUNTU_CONTAINER} \033[0m"
	@DOCKER_BUILDKIT=1 docker build -f Dockerfile.ubuntu -t ${UBUNTU_CONTAINER} .
	@docker run -it --name ubuntu-dev ${UBUNTU_CONTAINER}
	@docker commit ubuntu-dev ${NVIM_CONTAINER}
	@docker rm ubuntu-dev
#	@docker push ${NVIM_CONTAINER}

.PHONY: push
push:	## - Build and push container with neovim from latest head
	@docker push ${NVIM_CONTAINER}

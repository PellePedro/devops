
REGISTRY := registry.pellep.io
REGISTRY_FQDN=pellepedro
FEDORA_BASE := fedora-base:latest
UBUNTU_BASE := ubuntu-base:latest
IMAGE := devenv
FEDORA_DEVENV := fedenv
TAG := 0.1.0


.PHONY: help
help:	## - Show help message
	@printf "\033[32m\xE2\x9c\x93 usage: make [target]\n\n\033[0m"
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' Makefile | sort | awk 'BEGIN {FS = ":.*?## "}; {printf "\033[36m%-30s\033[0m %s\n", $$1, $$2}'

.PHONY: build-fedora-base
build-fedora-base:	## - build fedora base container
	@printf "\033[32m\xE2\x9c\x93 Building Fedora Base Container ${IMAGE} \033[0m"
	@sudo buildah rm --all
	@sudo ./build-base-container.sh ${FEDORA_BASE} fedora
	@sudo podman tag ${FEDORA_BASE} ${REGISTRY}/${FEDORA_BASE}

.PHONY: build-ubuntu-base
build-ubuntu-base:	## - build ubuntu base container
	@printf "\033[32m\xE2\x9c\x93 Building Ubuntu Base Container ${IMAGE} \033[0m"
	@sudo buildah rm --all
	@sudo ./build-base-container.sh ${UBUNTU_BASE} ubuntu
	@sudo podman tag ${UBUNTU_BASE} ${REGISTRY}/${UBUNTU_BASE}

.PHONY: build-fedenv-container
build-fedenv-container:
	@printf "\033[32m\xE2\x9c\x93 Building Fedora Dev Container ${IMAGE} \033[0m"
	@sudo buildah rm --all
	@sudo ./build-dev-container.sh ${FEDORA_BASE} ${FEDORA_DEVENV}
	@sudo podman tag ${FEDORA_DEVENV} ${REGISTRY}/${FEDORA_DEVENV}

.PHONY: build-dev-container
build-dev-container:
	@printf "\033[32m\xE2\x9c\x93 Building Ubuntu Dev Container ${IMAGE} \033[0m"
	@sudo buildah rm --all
	@sudo ./build-dev-container.sh ${UBUNTU_BASE} ${IMAGE}
	@sudo podman tag ${IMAGE} ${REGISTRY}/${IMAGE}

.PHONY: run
run:	## - run devenv container
	@printf "\033[32m\xE2\x9c\x93 Running Development Container ${IMAGE} \033[0m\n"
	@sudo podman run -it --rm -v /home/data/src:/home/pedro:Z -w /home/pedro  ${IMAGE} -name devenv

.PHONY: attach
attach:	## - attach devenv container
	@printf "\033[32m\xE2\x9c\x93 Attaching to Devenv Container ${IMAGE} \033[0m\n"
	@sudo podman attach  devenv

.PHONY: push
push:	## - tag and push the devenv container
	@printf "\033[32m\xE2\x9c\x93 Pushing Image ${IMAGE} to ${REGISTRY_FQDN} \033[0m"
	@sudo buildah push ${IMAGE} "docker://${REGISTRY_FQDN}/${IMAGE}:${TAG}"

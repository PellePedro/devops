
REGISTRY := registry.pellep.io
REGISTRY_FQDN=pellepedro
FEDORA_BASE := fedora-base:latest
UBUNTU_BASE := ubuntu-base:latest
UBUNTU_DEV := udev
FEDORA_DEV := fdev
TAG := 0.1.0


.PHONY: help
help:	## - Show help message
	@printf "\033[32m\xE2\x9c\x93 usage: make [target]\n\n\033[0m"
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' Makefile | sort | awk 'BEGIN {FS = ":.*?## "}; {printf "\033[36m%-30s\033[0m %s\n", $$1, $$2}'

.PHONY: build-fedora-base
build-fedora-base:	## - Build fedora base container
	@printf "\033[32m\xE2\x9c\x93 Building Fedora Base Container ${FEDORA_BASE} \033[0m"
	@sudo buildah rm --all
	@sudo ./build-base-container.sh ${FEDORA_BASE} fedora
	@sudo podman tag ${FEDORA_BASE} ${REGISTRY}/${FEDORA_BASE}

.PHONY: build-ubuntu-base
build-ubuntu-base:	## - Build ubuntu base container
	@printf "\033[32m\xE2\x9c\x93 Building Ubuntu Base Container ${UBUNTU_BASE} \033[0m"
	@sudo buildah rm --all
	@sudo ./build-base-container.sh ${UBUNTU_BASE} ubuntu
	@sudo podman tag ${UBUNTU_BASE} ${REGISTRY}/${UBUNTU_BASE}

.PHONY: build-fdev-container
build-fdev-container:	## - Build dev container based on Fedora
	@printf "\033[32m\xE2\x9c\x93 Building Fedora Dev Container ${FEDORA_DEV} \033[0m"
	@sudo buildah rm --all
	@sudo ./build-dev-container.sh ${FEDORA_BASE} ${FEDORA_DEV}
	@sudo podman tag ${FEDORA_DEV} ${REGISTRY}/${FEDORA_DEV}

.PHONY: build-udev-container
build-udev-container:	## - Build dev container based on Ubuntu
	@printf "\033[32m\xE2\x9c\x93 Building Ubuntu Dev Container ${UBUNTU_DEV} \033[0m"
	@sudo buildah rm --all
	@sudo ./build-dev-container.sh ${UBUNTU_BASE} ${UBUNTU_DEV}
	@sudo podman tag ${UBUNTU_DEV} ${REGISTRY}/${UBUNTU_DEV}

.PHONY: frun	## - Run dev container based on Fedora
frun:	## - run devenv container
	@printf "\033[32m\xE2\x9c\x93 Running Development Container ${FEDORA_DEV} \033[0m\n"
	@sudo podman run -it  -v /home/pedro:/home/pedro:z -w /home/pedro  ${FEDORA_DEV} -name fdev

.PHONY: urun	## - Run dev container based on Ubuntu
urun:	## - run devenv container
	@printf "\033[32m\xE2\x9c\x93 Running Development Container ${UBUNTU_DEV} \033[0m\n"
	@sudo podman run -it --security-opt label=disable -v /home/pedro:/home/devops/src   ${UBUNTU_DEV} -name udev

.PHONY: push
push:	## - Tag and push the udev container
	@printf "\033[32m\xE2\x9c\x93 Pushing Image ${UBUNTU_DEV} to ${REGISTRY_FQDN} \033[0m"
	@sudo buildah push ${IMAGE} "docker://${REGISTRY_FQDN}/${UBUNTU_DEV}:${TAG}"

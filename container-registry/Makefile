.PHONY: help
help:	## - Show help message
	@printf "\033[32m\xE2\x9c\x93 usage: make [target]\n\n\033[0m"
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' Makefile | sort | awk 'BEGIN {FS = ":.*?## "}; {printf "\033[36m%-30s\033[0m %s\n", $$1, $$2}'

.PHONY: start-registry
start-registry:	## - start registry
	@printf "\033[32m\xE2\x9c\x93 Starting Container Registry \033[0m"
	@mkdir -p registry
	@sudo podman run --privileged -d --name registry -p 5000:5000 \
		-v $(shell pwd)/registry:/var/lib/registry:Z \
									--restart=always \
									registry:2

.PHONY: stop-registry
stop-registry:	## - stop registry
	@printf "\033[32m\xE2\x9c\x93 Stopping Container Registry \033[0m"
	@mkdir -p registry
	@sudo podman rm registry

.PHONY: list
list:	## - list registry
	@sudo podman ps | grep registry

.PHONY: inspect
inspect:	## - list registry
	@sudo podman inspect registry

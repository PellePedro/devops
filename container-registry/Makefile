REGISTRY := registry.pellep.io

.PHONY: help
help:	## - Show help message
	@printf "\033[32m\xE2\x9c\x93 usage: make [target]\n\n\033[0m"
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' Makefile | sort | awk 'BEGIN {FS = ":.*?## "}; {printf "\033[36m%-30s\033[0m %s\n", $$1, $$2}'

.PHONY: start-registry
start-registry:	## - start registry
	@printf "\033[32m\xE2\x9c\x93 Starting Container Registry \033[0m"
	@mkdir -p registry
	@sudo docker run --privileged -d --name registry --net=host \
				-v "$(shell pwd)/auth":/certs:z \
				-v "$(shell pwd)/registry":/var/lib/registry:z \
				-v "$(shell pwd)/auth":/auth:z \
				-e REGISTRY_HTTP_TLS_CERTIFICATE="/certs/registry.crt" \
				-e REGISTRY_HTTP_TLS_KEY="/certs/registry.key" \
				-e REGISTRY_HTTP_SECRET=ALongRandomSecretForRegistry \
				-e REGISTRY_AUTH_HTPASSWD_PATH=/auth/htpasswd \
				-e REGISTRY_AUTH_HTPASSWD_REALM=Registry \
				-p 5000:5000 --name registry --restart=always registry:2

.PHONY: stop-registry
stop-registry:	## - stop registry
	@printf "\033[32m\xE2\x9c\x93 Stopping Container Registry \033[0m"
	@mkdir -p registry
	@sudo docker rm registry -f

.PHONY: list
list:	## - list registry
	@sudo docker ps | grep registry

.PHONY: inspect
inspect:	## - list registry
	@sudo docker inspect registry

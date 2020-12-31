REGISTRY := registry.pellep.io
MASTER := master

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

.PHONY: generate-credentials
generate-credentials:	## - generate credentials
	@printf "\033[32m\xE2\x9c\x93 Generate Certificate and Credentials \033[0m"
	@rm -rf auth
	@./make-cert-credential.sh ${REGISTRY}

.PHONY: update-lxc-ca-trust
update-lxc-ca-trust:	## - generate credentials
	@printf "\033[32m\xE2\x9c\x93 Update lxc containers to trust registry ca \033[0m"
	@./update-ca-trust.sh

.PHONY: pull-lxc-kubeconfig
pull-lxc-kubeconfig:	## - Pull kubeconfig from lxc master
	@printf "\033[32m\xE2\x9c\x93 Pull kubeconfig from lxc master \033[0m"
	@./pull-lxc-kubeconfig.sh ${MASTER}

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

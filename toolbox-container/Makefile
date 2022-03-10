IMAGE := docker.io/pellepedro/toolbox:1.0.0

.PHONY: help
help:	## - Show help message
	@printf "\033[32m\xE2\x9c\x93 usage: make [target]\n\n\033[0m"
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' Makefile | sort | awk 'BEGIN {FS = ":.*?## "}; {printf "\033[36m%-30s\033[0m %s\n", $$1, $$2}'

.PHONY: build
build:	## - build utils container
	@printf "\033[32m\xE2\x9c\x93 Build utils Containers \033[0m"
	@docker build -t ${IMAGE} .
	@docker push ${IMAGE}

.PHONY: deploy
deploy:	## - deploy utils container
	@printf "\033[32m\xE2\x9c\x93 Deploy utils Containers \033[0m"
	@kubectl create -f deployment

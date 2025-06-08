.ONESHELL:
SHELL := /bin/bash

include Vars.mk

# ** Example Variables for Vars.mk **
#
# BASE_IMAGE_NAME = basedev
# VERSION_TAG = v0.1
# EMAIL = example@outlook.com
# USER = Rick
# PASSWD = root
# DEV_CONTAINER_NAME = godev
# PROJECT_PATH = 

LABEL = basename
LABEL_BASE = self
LABEL_DERIVATIVE = $(BASE_IMAGE_NAME)

all: help

.PHONY: cleancur
cleancur: ## Clean current docker base image
	@IMG=${BASE_IMAGE_NAME}:${VERSION_TAG}; \
	docker images $${IMG} -q --filter "label=${LABEL}" | xargs -r docker rmi

.PHONY: cleanbase
cleanbase: ## Clean all old docker base images
	@IMG=${BASE_IMAGE_NAME}:${VERSION_TAG}; \
	docker images -q --filter "label=${LABEL}" --filter "before=$${IMG}" | xargs -r docker rmi -f

.PHONY: stopall
stopall: ## Stop all dev containers
	@CONTAINERS_TO_STOP=$$(docker ps -a -q --filter "label=${LABEL}"); \
	echo "Stopping dev containers..."; \
	if [ -n "$$CONTAINERS_TO_STOP" ]; then docker stop $${CONTAINERS_TO_STOP}; fi

.PHONY: rmall 
rmall: ## DANGER! Remove all dev containers
	@CONTAINERS_TO_REMOVE=$$(docker ps -a -q --filter "label=${LABEL}"); \
	echo "Removing dev containers..."; \
	if [ -n "$$CONTAINERS_TO_REMOVE" ]; then docker rm $${CONTAINERS_TO_REMOVE}; fi

.PHONY: cleanall
cleanall: stopall rmall ## DANGER! Clean all dev container images
	@docker images -q --filter "label=${LABEL}" | xargs -r docker rmi

.PHONY: build
build: ## Build base image to version
	@IMG=${BASE_IMAGE_NAME}:${VERSION_TAG}
	@echo "Current image version tagged: $${IMG}"
	# if image not exist then build
	if [ -z "$$(docker images -q $${IMG} 2> /dev/null)" ]; then 
		docker build --no-cache -f=Dockerfile.base -t=$${IMG} --build-arg EMAIL=${EMAIL} --build-arg "USER=${USER}" --build-arg "PASSWD=${PASSWD}" --label "${LABEL}=${LABEL_BASE}" .
	else
		@echo "Do nothing because image version tag $${IMG} exists"
	fi

.PHONY: node
node: build ## Build node image from the base to version
	IMG=${BASE_IMAGE_NAME}-node:${VERSION_TAG}
	if [ -z "$$(docker images -q $${IMG} 2> /dev/null)" ]; then
		docker build -f=Dockerfile.node -t=$${IMG} --build-arg BASEIMAGE=$${IMG} --label ${LABEL}=${LABEL_DERIVATIVE} .
	else
		@echo "Do nothing because image version tag $${IMG} exists"
	fi

.PHONY: go
go: build ## Build golang image from the base to version
	IMG=${BASE_IMAGE_NAME}-golang:${VERSION_TAG}
	if [ -z "$(docker images -q $${IMG} 2> /dev/null)" ]; then
		docker build -f=Dockerfile.golang -t=$${IMG} --build-arg BASEIMAGE=$${IMG} --label ${LABEL}=${LABEL_DERIVATIVE} .
	else
		@echo "Do nothing because image version tag $${IMG} exists"
	fi

.PHONY: exec
exec:  ## Run container and tmux into it using ssh. Variables: PP (project path) DN (dev container name) IMG (image name)
	@IMG=${BASE_IMAGE_NAME}:${VERSION_TAG}
	PP=${PROJ_PATH}
	DN=${DEV_CONTAINER_NAME}
	CONTAINER=$$(docker ps -a --format "{{.ID}}" -f name=${DEV_CONTAINER_NAME})
	if [ -z "$${CONTAINER}" ]; then
		echo "Running $$IMG..."
		docker run -v $$(echo ~)/workspace/$${PP}:/root/workspace/$${PP} -p 8654:22 --name $${DN} -d -it $${IMG}
	else
		echo "Restarting $$IMG..."
		docker restart $${CONTAINER}
	fi

.PHONY: port
port:  ## Local port forward from dev container by SSH tunneling. Variables: LP (local port) RP (remote port)
	@LP=8080
	RP=8080
	echo "SSH local port forward $${LP}->localhost:$${RP}"
	ssh -L $${LP}:localhost:$${RP} root@localhost -p 8654
	
.PHONY: ls
ls:  ## List all dev containers
	@docker ps -a --filter "label=${LABEL}"

.PHONY: lsi
lsi:  ## List all dev containers images
	@docker images -a --filter "label=${LABEL}"

.PHONY: help
help: ## Display available commands
	@cat $(MAKEFILE_LIST) | grep -E '^[a-zA-Z_-]+:.*?## .*$$' | awk \
		'BEGIN {FS = ":.*?## "}; {printf "\033[36m%-30s\033[0m %s\n", $$1, $$2}'


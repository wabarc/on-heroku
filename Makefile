DOCKER ?= $(shell which docker || which podman)
APPNAME ?= $(shell bash -c 'read -p "App name: " enter; echo $${enter}')
REGISTRY := registry.heroku.com

.PHONY: build
build:
	@$(MAKE) web
	@$(MAKE) worker

.PHONY: web
web:
	@$(DOCKER) build -t registry.heroku.com/${APPNAME}/web -f ./webapp/Dockerfile.web ./webapp

.PHONY: worker
worker:
	@$(DOCKER) build -t registry.heroku.com/${APPNAME}/worker -f ./worker/Dockerfile.worker ./worker

.PHONY: login
login:
	@$(DOCKER) login --username="$(shell read -p "username: " username; echo $${username})" --password="$(shell read -p "password: " password; echo $${password})" ${REGISTRY}

.PHONY: logout
logout:
	@$(DOCKER) logout ${REGISTRY}

.PHONY: push
push:
	@$(DOCKER) push registry.heroku.com/${APPNAME}/web
	@$(DOCKER) push registry.heroku.com/${APPNAME}/worker

.PHONY: run
run:
	@$(MAKE) worker
	$(DOCKER) run -ti --rm --init -v ${PWD}:/on-heroku --entrypoint="" --user=root registry.heroku.com/${APPNAME}/worker /bin/sh

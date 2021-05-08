DOCKER ?= $(shell which docker || which podman)
APPNAME ?= $(shell bash -c 'read -p "App name: " enter; echo $${enter}')
REGISTRY := registry.heroku.com

.PHONY: build
build:
	@$(MAKE) build-web
	@$(MAKE) build-worker

.PHONY: build-web
build-web:
	@$(DOCKER) build -t registry.heroku.com/${APPNAME}/web -f ./webapp/Dockerfile.web ./webapp

.PHONY: build-worker
build-worker:
	@$(DOCKER) build -t registry.heroku.com/${APPNAME}/worker -f ./worker/Dockerfile.worker ./worker

.PHONY: login
login:
	@heroku container:login

.PHONY: logout
logout:
	@heroku container:logout

.PHONY: push
push:
ifeq (,$(findstring $(DOCKER),podman))
	@$(DOCKER) push --format=v2s2 registry.heroku.com/${APPNAME}/web
	@$(DOCKER) push --format=v2s2 registry.heroku.com/${APPNAME}/worker
else
	@$(DOCKER) push registry.heroku.com/${APPNAME}/web
	@$(DOCKER) push registry.heroku.com/${APPNAME}/worker
endif

.PHONY: release
release:
	@heroku container:release --app=${APPNAME} web
	@heroku container:release --app=${APPNAME} worker

# Docker in Docker or Podman in Podman
.PHONY: manual
manual:
ifeq (,$(findstring $(DOCKER),podman))
	@$(DOCKER) run --privileged --rm -ti --ulimit host -v ${PWD}:/on-heroku -v /dev/fuse:/dev/fuse:rw -e HEROKU_API_KEY="$(shell read -p 'Heroku API Key: ' key; echo $${key})" quay.io/podman/stable \
		bash -c "ln -s /usr/bin/podman /usr/bin/docker; cd /on-heroku; dnf update -y; dnf install make vim git curl -y; \
			curl https://cli-assets.heroku.com/install.sh | sh; make login; bash"
else
	@$(DOCKER) run --privileged --rm -ti --ulimit host -v ${PWD}:/on-heroku -e HEROKU_API_KEY="$(shell read -p 'Heroku API Key: ' key; echo $${key})" docker:dind \
		sh -c "cd /on-heroku; apk add --no-cache build-base vim git curl;
			curl https://cli-assets.heroku.com/install.sh | sh; make login; sh"
endif

.PHONY: manual-build-web
manual-build-web:
	@$(MAKE) build-web

.PHONY: manual-build-worker
manual-build-worker:
	@$(MAKE) build-worker

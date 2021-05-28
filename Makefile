# Heroku documentation: https://devcenter.heroku.com/articles/container-registry-and-runtime
#
HEROKU ?= $(shell which heroku)
DOCKER ?= $(shell which docker || which podman)
APPNAME ?= $(shell bash -c 'read -p "App name: " enter; echo $${enter}')
REGISTRY := registry.heroku.com

.PHONY: build
build:
	@$(DOCKER) build -t registry.heroku.com/${APPNAME}/web .

.PHONY: login
login:
	#@heroku container:login
	@echo "Login container registry using Docker CLI"
	@$(DOCKER) login --username=_ --password="$(shell read -p 'Heroku API Key: ' key; echo $${key})" ${REGISTRY}

.PHONY: logout
logout:
	@echo "Logout container registry using Docker CLI"
	@$(DOCKER) login --username=_ --password="$(shell read -p 'Heroku API Key: ' key; echo $${key})" ${REGISTRY}

.PHONY: push
push:
ifeq (,$(findstring $(DOCKER),podman))
	@echo "Pushing webapp"
	@$(DOCKER) push --format=v2s2 registry.heroku.com/${APPNAME}/web
else
	@$(DOCKER) push registry.heroku.com/${APPNAME}/web
endif

.PHONY: release
release:
ifeq (,$(findstring $(HEROKU),heroku))
	@echo "Release webapp"
	@$(HEROKU) container:release --app=${APPNAME} web
else
	@echo "Release container by API, unsupport currently. Please run `make manual` first to releasing app"
endif

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

PROJECT?=lemonade
DOCKER_NAME?=darthjee/$(PROJECT)
VERSION?=0.0.1

build:
	docker build ./ -t $(DOCKER_NAME):latest -t $(DOCKER_NAME):$(VERSION)

push:
	docker push $(DOCKER_NAME):$(VERSION)
	docker push $(DOCKER_NAME):latest

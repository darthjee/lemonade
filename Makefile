PROJECT=lemonade
DOCKER_NAME=darthjee/$(PROJECT)

build:
	docker build ./ -t $(DOCKER_NAME)

push:
	docker push $(DOCKER_NAME)

GOPATH=$(shell go env GOPATH)
IMAGE_REGISTRY=dockerhub
IMAGE_NAMESPACE ?= hyperjump
IMAGE_NAME ?= monika
CURRENT_PATH=$(shell pwd)
COMMIT_ID ?= $(shell git rev-parse --short HEAD)
VERSION=v1.1.0
GO111MODULE=on


docker:
	docker build -t $(IMAGE_NAMESPACE)/$(IMAGE_NAME):latest -f ./Dockerfile .

docker-build-commit: build
	docker build -t $(IMAGE_NAMESPACE)/$(IMAGE_NAME):$(COMMIT_ID) -f ./Dockerfile .

docker-build: docker-build-commit
	docker tag $(IMAGE_NAMESPACE)/$(IMAGE_NAME):$(COMMIT_ID) $(IMAGE_NAMESPACE)/$(IMAGE_NAME):$(VERSION)
	docker tag $(IMAGE_NAMESPACE)/$(IMAGE_NAME):$(COMMIT_ID) $(IMAGE_NAMESPACE)/$(IMAGE_NAME):latest

docker-push: docker-build
	docker push $(IMAGE_NAMESPACE)/$(IMAGE_NAME):latest

docker-stop:
	-docker stop $(IMAGE_NAME)

docker-rm: docker-stop
	-docker rm $(IMAGE_NAME)

docker-run: docker-rm docker
	docker run --name $(IMAGE_NAME) -e "MONIKA_JSON_CONFIG=/config/config.json" -v /mnt/c/Users/User/Laboratory/testmonika:/config --detach $(IMAGE_NAMESPACE)/$(IMAGE_NAME):latest
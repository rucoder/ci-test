VERSION=$(shell git rev-parse --short=12 HEAD)
BUILD_USER=$(shell id -un)
DIRTY=$(shell git diff --quiet || echo '-dirty')


DOCKER_TAG=mikemzed/ci-test:ci-test-$(BUILD_USER)-$(VERSION)$(DIRTY)

%.o: %c
	gcc -c $< -o $@

ci-test: src/main.o
	gcc src/main.o -o ci-test

clean:
	rm -f src/*.o ci-test

docker-build:
	docker buildx build --platform=linux/amd64 -t $(DOCKER_TAG) . --load

docker-push:
	docker push $(DOCKER_TAG)

build: ci-test
.PHONY: build docker-build docker-push clean
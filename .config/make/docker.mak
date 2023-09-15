## —— Docker —————————————————————————————————————————————————————————————————————————————————————
TAG ?= local
DOCKER_REGISTRY ?= vitabaks

.PHONY: docker-build
docker-build: ## Run docker build image (example: make docker-build TAG=my_tag)
	docker build --tag postgresql_cluster:$(TAG) --file Dockerfile .

.PHONY: docker-push
docker-push: ## Push image to Dockerhub (example: make docker-push TAG=my_tag DOCKER_REGISTRY=my_repo DOCKER_REGISTRY_USER="my_username" DOCKER_REGISTRY_PASSWORD="my_password")
	@echo "Building & pushing container image with tag $(TAG)";
	echo "$(DOCKER_REGISTRY_PASSWORD)" | docker login --username "$(DOCKER_REGISTRY_USER)" --password-stdin
	docker tag postgresql_cluster:$(TAG) $(DOCKER_REGISTRY)/postgresql_cluster:$(TAG)
	docker push $(DOCKER_REGISTRY)/postgresql_cluster:$(TAG)

.PHONY: docker-lint
docker-lint: ## Run hadolint command to lint Dokerfile
	docker run --rm -i -v ./Dockerfile:/Dockerfile \
	hadolint/hadolint hadolint --ignore DL3002 --ignore DL3008 --ignore DL3059 /Dockerfile

.PHONY: docker-tests
docker-tests: ## Run tests for docker
	$(MAKE) docker-lint
	$(MAKE) docker-build

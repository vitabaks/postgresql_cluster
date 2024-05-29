## —— Docker —————————————————————————————————————————————————————————————————————————————————————
TAG ?= local
DOCKER_REGISTRY ?= vitabaks

.PHONY: docker-lint docker-lint-console-db docker-lint-console-api docker-lint-console-ui
docker-lint: docker-lint-console-db ## Lint all Dockerfiles 
#docker-lint: docker-lint-automation docker-lint-console-db docker-lint-console-api docker-lint-console-ui ## Lint all Dockerfiles 

#docker-lint-automation: ## Lint postgresql_cluster Dockerfile
#	docker run --rm -i -v ./Dockerfile:/Dockerfile \
#	hadolint/hadolint hadolint --ignore DL3002 --ignore DL3008 --ignore DL3059 /Dockerfile

docker-lint-console-db: ## Lint console db Dockerfile
	@echo "Lint console db container Dockerfile"
	docker run --rm -i -v $(PWD)/console/db/Dockerfile:/Dockerfile \
	hadolint/hadolint hadolint --ignore DL3002 --ignore DL3008 --ignore DL3059 --ignore DL4001 /Dockerfile

#docker-lint-console-api: ## Lint api Dockerfile
#	@echo "Lint console api container Dockerfile"
# 	docker run --rm -i -v $(PWD)/console/service/Dockerfile:/Dockerfile \
# 	hadolint/hadolint hadolint --ignore DL3002 --ignore DL3008 --ignore DL3059 /Dockerfile

#docker-lint-console-ui: ## Lint ui Dockerfile
#	@echo "Lint console ui container Dockerfile"
# 	docker run --rm -i -v $(PWD)/console/ui/Dockerfile:/Dockerfile \
# 	hadolint/hadolint hadolint --ignore DL3002 --ignore DL3008 --ignore DL3059 /Dockerfile


.PHONY: docker-build docker-build-console-db docker-build-console-api docker-build-console-ui
docker-build: docker-build-console-db ## Build all Dockerfiles (example: make docker-build TAG=my_tag)
#docker-build: docker-build-automation docker-build-console-db docker-build-console-api docker-build-console-ui ## Build for all Docker images

#docker-build-automation: ## Build postgresql_cluster image
#	@echo "Build postgresql_cluster container image with tag $(TAG)";
#	docker build --no-cache --tag postgresql_cluster:$(TAG) --file Dockerfile .

docker-build-console-db: ## Build console db image
	@echo "Build console db container image with tag $(TAG)"
	docker build --no-cache --tag postgresql_cluster_console_db:$(TAG) --file console/db/Dockerfile .

# docker-build-console-api: ## Build api image
# 	@echo "Build console api container image with tag $(TAG)"
# 	docker build --no-cache --tag postgresql_cluster_console_api:$(TAG) --file console/service/Dockerfile .

# docker-build-console-ui: ## Build ui image
# 	@echo "Build console ui container image with tag $(TAG)"
# 	docker build --no-cache --tag postgresql_cluster_console_ui:$(TAG) --file console/ui/Dockerfile .


.PHONY: docker-push docker-push-console-db docker-push-console-api docker-push-console-ui
docker-push: docker-push-console-db ## Push all images to Dockerhub (example: make docker-push TAG=my_tag DOCKER_REGISTRY=my_repo DOCKER_REGISTRY_USER="my_username" DOCKER_REGISTRY_PASSWORD="my_password")
#docker-push: docker-push-automation docker-push-console-db docker-push-console-api docker-push-console-ui ## Push all images to Dockerhub

#docker-push-automation: ## Push postgresql_cluster to Dockerhub
#	@echo "Push postgresql_cluster container image with tag $(TAG)";
#	echo "$(DOCKER_REGISTRY_PASSWORD)" | docker login --username "$(DOCKER_REGISTRY_USER)" --password-stdin
#	docker tag postgresql_cluster:$(TAG) $(DOCKER_REGISTRY)/postgresql_cluster:$(TAG)
#	docker push $(DOCKER_REGISTRY)/postgresql_cluster:$(TAG)

docker-push-console-db: ## Push console db image to Dockerhub
	@echo "Push console db container image with tag $(TAG)"
	echo "$(DOCKER_REGISTRY_PASSWORD)" | docker login --username "$(DOCKER_REGISTRY_USER)" --password-stdin
	docker tag postgresql_cluster_console_db:$(TAG) $(DOCKER_REGISTRY)/postgresql_cluster_console_db:$(TAG)
	docker push $(DOCKER_REGISTRY)/postgresql_cluster_console_db:$(TAG)

# docker-push-console-api: ## Push console api image to Dockerhub
# 	@echo "Push console api container image with tag $(TAG)"
# 	echo "$(DOCKER_REGISTRY_PASSWORD)" | docker login --username "$(DOCKER_REGISTRY_USER)" --password-stdin
# 	docker tag postgresql_cluster_console_api:$(TAG) $(DOCKER_REGISTRY)/postgresql_cluster_console_api:$(TAG)
# 	docker push $(DOCKER_REGISTRY)/postgresql_cluster_console_api:$(TAG)

# docker-push-console-ui: ## Push console ui image to Dockerhub
# 	@echo "Push console ui container image with tag $(TAG)"
# 	echo "$(DOCKER_REGISTRY_PASSWORD)" | docker login --username "$(DOCKER_REGISTRY_USER)" --password-stdin
# 	docker tag postgresql_cluster_console_ui:$(TAG) $(DOCKER_REGISTRY)/postgresql_cluster_console_ui:$(TAG)
# 	docker push $(DOCKER_REGISTRY)/postgresql_cluster_console_ui:$(TAG)

.PHONY: docker-tests
docker-tests: ## Run tests for docker
	$(MAKE) docker-lint
	$(MAKE) docker-build

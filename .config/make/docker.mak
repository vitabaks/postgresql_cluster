## —— Docker —————————————————————————————————————————————————————————————————————————————————————
.PHONY: docker-build
docker-build: ## Run docker build image in local
	docker build --tag postgresql_cluster:local --file .config/gitpod/Dockerfile .

.PHONY: docker-lint
docker-lint: ## Run hadolint command to lint Dokerfile
	docker run --rm -i hadolint/hadolint < .config/gitpod/Dockerfile

.PHONY: docker-tests
docker-tests: ## Run tests for docker
	$(MAKE) docker-build
	$(MAKE) docker-lint

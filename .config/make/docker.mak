## —— Docker —————————————————————————————————————————————————————————————————————————————————————
.PHONY: docker-build
docker-build: ## Run docker build image in local
	docker build --tag postgresql_cluster:local --file .gitpod.Dockerfile .

.PHONY: docker-lint
docker-lint: ## Run hadolint command to lint Dokerfile
	docker run --rm -i hadolint/hadolint < .gitpod.Dockerfile
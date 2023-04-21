## —— Yaml ———————————————————————————————————————————————————————————————————————————————————————
.PHONY: yaml-bootstrap
yaml-bootstrap: ## Bootstrap Yaml
	$(MAKE) yaml-linters-install

.PHONY: yaml-linters-install
yaml-linters-install: ## Install or upgrade linters
	source .venv/bin/activate
	pip install --upgrade yamllint

.PHONY: yamllint
yamllint: ## Run yamllint
	source .venv/bin/activate
	yamllint -c .config/.yamllint .

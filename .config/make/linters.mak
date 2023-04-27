## —— Linter —————————————————————————————————————————————————————————————————————————————————————

# Activate virtual environment
ACTIVATE_VENV = source .venv/bin/activate

# Configuration files
YAMLLINT_CONFIG = .yamllint
FLAKE8_CONFIG = .config/.flake8

.PHONY: linter-yamllint
linter-yamllint: ## Lint YAML files using yamllint
	$(ACTIVATE_VENV) && \
	yamllint --strict -c $(YAMLLINT_CONFIG) .

.PHONY: linter-ansible-lint
linter-ansible-lint: ## Lint Ansible files using ansible-lint
	$(ACTIVATE_VENV) && \
	ansible-lint --force-color --offline --parseable --strict

.PHONY: linter-flake8
linter-flake8: ## Lint Python files using flake8
	$(ACTIVATE_VENV) && \
	flake8 --config $(FLAKE8_CONFIG)

.PHONY: lint
lint: linter-yamllint linter-ansible-lint linter-flake8 ## Run all linters

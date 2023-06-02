## —— Linter —————————————————————————————————————————————————————————————————————————————————————

# Activate virtual environment
ACTIVATE_VENV = source .venv/bin/activate

# Configuration files
YAMLLINT_CONFIG = .config/.yamllint
FLAKE8_CONFIG = .config/.flake8

.PHONY: linter-yamllint
linter-yamllint: ## Lint YAML files using yamllint
	echo "yamllint #############################################################"
	$(ACTIVATE_VENV) && \
	yamllint --strict -c $(YAMLLINT_CONFIG) .

.PHONY: linter-ansible-lint
linter-ansible-lint: ## Lint Ansible files using ansible-lint
	echo "ansible-lint #########################################################"
	$(ACTIVATE_VENV) && \
	ansible-lint --force-color --parseable

.PHONY: linter-flake8
linter-flake8: ## Lint Python files using flake8
	echo "flake8 ###############################################################"
	$(ACTIVATE_VENV) && \
	flake8 --config $(FLAKE8_CONFIG)

.PHONY: lint
lint: ## Run all linters
	$(MAKE) linter-yamllint
	$(MAKE) linter-ansible-lint
	$(MAKE) linter-flake8

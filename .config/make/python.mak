# Python default launcher
python_launcher ?= python3.10
python_requirements_file ?= requirements.txt
python_requirements_dev_file ?= .config/python/dev/requirements.txt

## —— Python —————————————————————————————————————————————————————————————————————————————————————
.PHONY: python-bootstrap
python-bootstrap: ## Bootstrap python
	$(MAKE) python-venv-init
	$(MAKE) python-venv-upgrade
	$(MAKE) python-venv-requirements

.PHONY: python-bootstrap-dev
python-bootstrap-dev: ## Bootstrap python for dev env
	$(MAKE) python-venv-requirements-dev
	$(MAKE) python-venv-linters-install

# ===============================================================================================
# .venv
# ===============================================================================================
.PHONY: python-venv-init
python-venv-init: ## Create venv ".venv/" if not exist
	if [ ! -d .venv ] ; then
		$(python_launcher) -m venv .venv
	fi

.PHONY: python-venv-upgrade
python-venv-upgrade: ## Upgrade venv with pip, setuptools and wheel
	source .venv/bin/activate
	pip install --upgrade pip setuptools wheel

.PHONY: python-venv-requirements
python-venv-requirements: ## Install or upgrade from $(python_requirements_file)
	source .venv/bin/activate
	pip install --upgrade --requirement $(python_requirements_file)

.PHONY: python-venv-requirements-dev
python-venv-requirements-dev: ## Install or upgrade from $(python_requirements_dev_file)
	source .venv/bin/activate
	pip install --upgrade --requirement $(python_requirements_dev_file)

.PHONY: python-venv-linters-install
python-venv-linters-install: ## Install or upgrade linters
	source .venv/bin/activate
	pip install --upgrade flake8

.PHONY: python-venv-purge
python-venv-purge: ## Remove venv ".venv/" folder
	rm -rf .venv

# ===============================================================================================
# Utils
# ===============================================================================================
.PHONY: python-purge-cache
python-purge-cache: ## Purge cache to avoid used cached files
	if [ -d .venv ] ; then
		source .venv/bin/activate
		pip cache purge
	fi

.PHONY: python-version
python-version: ## Displays the python version used for the .venv
	source .venv/bin/activate
	$(python_launcher) --version

.PHONY: python-flake8
python-flake8: ## Run flake8 linter for python
	source .venv/bin/activate
	flake8 --config .config/.flake8

.PHONY: python-pytest
python-pytest: ## Run pytest to test python scripts
	source .venv/bin/activate
	cd scripts/
	$(python_launcher) -m pytest

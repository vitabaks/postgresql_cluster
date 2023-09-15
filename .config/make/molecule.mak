# Activate virtual environment
ACTIVATE_VENV = . .venv/bin/activate

## —— Molecule ———————————————————————————————————————————————————————————————————————————————————

.PHONY: molecule-test
molecule-test: ## Run test sequence for default scenario
	$(ACTIVATE_VENV) && molecule test

.PHONY: molecule-destroy
molecule-destroy: ## Run destroy sequence for default scenario
	$(ACTIVATE_VENV) && molecule destroy

.PHONY: molecule-converge
molecule-converge: ## Run converge sequence for default scenario
	$(ACTIVATE_VENV) && molecule converge

.PHONY: molecule-reconverge
molecule-reconverge: ## Run destroy and converge sequence for default scenario
	$(ACTIVATE_VENV) && molecule destroy && molecule converge

.PHONY: molecule-test-all
molecule-test-all: ## Run test sequence for all scenarios
	$(ACTIVATE_VENV) && molecule test --all

.PHONY: molecule-destroy-all
molecule-destroy-all: ## Run destroy sequence for all scenarios
	$(ACTIVATE_VENV) && molecule destroy --all

.PHONY: molecule-test-scenario
molecule-test-scenario: ## Run molecule test with specific scenario (example: make molecule-test-scenario MOLECULE_SCENARIO="scenario_name")
	$(ACTIVATE_VENV) && molecule test --scenario-name $(MOLECULE_SCENARIO)

.PHONY: molecule-destroy-scenario
molecule-destroy-scenario: ## Run molecule destroy with specific scenario (example: make molecule-destroy-scenario MOLECULE_SCENARIO="scenario_name")
	$(ACTIVATE_VENV) && molecule destroy --scenario-name $(MOLECULE_SCENARIO)

.PHONY: molecule-converge-scenario
molecule-converge-scenario: ## Run molecule converge with specific scenario (example: make molecule-converge-scenario MOLECULE_SCENARIO="scenario_name")
	$(ACTIVATE_VENV) && molecule converge --scenario-name $(MOLECULE_SCENARIO)

.PHONY: molecule-dependency
molecule-dependency: ## Run dependency sequence
	$(ACTIVATE_VENV) && molecule dependency

.PHONY: molecule-verify
molecule-verify: ## Run verify sequence
	$(ACTIVATE_VENV) && molecule verify

.PHONY: molecule-login
molecule-login: ## Log in to one instance using custom host IP (example: make molecule-login MOLECULE_HOST="10.172.0.20")
	$(ACTIVATE_VENV) && molecule login --host $(MOLECULE_HOST)

.PHONY: molecule-login-scenario
molecule-login-scenario: ## Log in to one instance using custom host IP and scenario name (example: make molecule-login-scenario MOLECULE_HOST="10.172.1.20" MOLECULE_SCENARIO="scenario_name")
	$(ACTIVATE_VENV) && molecule login --host $(MOLECULE_HOST) --scenario-name $(MOLECULE_SCENARIO)

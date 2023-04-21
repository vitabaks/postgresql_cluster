.PHONY: all test SHELL

# Makefile global config
.DEFAULT_GOAL:=help
.EXPORT_ALL_VARIABLES:
.ONESHELL:
.SILENT:
MAKEFLAGS += "-j$(NUM_CORES) -l$(NUM_CORES)"
MAKEFLAGS += --silent
SHELL:=/bin/bash

# Makefile colors config
bold=$(shell tput bold)
normal=$(shell tput sgr0)
errorTitle=$(shell tput setab 1 && tput bold && echo '\n')
recommendation=$(shell tput setab 4)
underline=$(shell tput smul)
reset=$(shell tput -Txterm sgr0)
black=$(shell tput setaf 0)
red=$(shell tput setaf 1)
green=$(shell tput setaf 2)
yellow=$(shell tput setaf 3)
blue=$(shell tput setaf 4)
magenta=$(shell tput setaf 5)
cyan=$(shell tput setaf 6)
white=$(shell tput setaf 7)

define HEADER
How to use me:
 make && make bootstrap
 make ${cyan}<target>${reset}

endef
export HEADER

python_launcher := python3.10

-include .config/make/help.mak
-include .config/make/python.mak
-include .config/make/molecule.mak

## —— Bootstrap collection ———————————————————————————————————————————————————————————————————————
.PHONY: bootstrap
bootstrap: ## Bootstrap Ansible collection
	$(MAKE) python-bootstrap
	$(MAKE) python-bootstrap-dev

## —— Virtualenv ————————————————————————————————————————————————————————————————————————————————
.PHONY: reinitialization
reinitialization: ## Return to an initial state of Bootstrap Ansible collection
	rm -rf .venv/
	rm -rf vendor/
	rm -f *.mak
	$(MAKE) bootstrap

.PHONY: clean
clean: ## Clean collection
	rm -rf .venv/
	rm -rf .pytest_cache/
	rm -rf scripts/.pytest_cache/
	rm -rf scripts/tests/__pycache__/
	rm -rf scripts/modules/__pycache__/
	rm -rf scripts/modules/services/__pycache__/
	rm -rf scripts/modules/utils/__pycache__/
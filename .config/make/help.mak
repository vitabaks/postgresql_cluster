## —— Help ———————————————————————————————————————————————————————————————————————————————————————
.PHONY: help
help: ## Help command
	echo -e "$$HEADER"
	grep -E '(^[a-zA-Z0-9_-]+:.*?## .*$$)|(^## )' $(MAKEFILE_LIST) | sed 's/^[^:]*://g' | awk 'BEGIN {FS = ":.*?## | #"} ; {printf "${cyan}%-30s${reset} ${white}%s${reset} ${green}%s${reset}\n", $$1, $$2, $$3}' | sed -e 's/\[36m##/\n[32m##/'

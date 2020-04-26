build: ## Build the jenkins agents as docker images.
	$(MAKE) -C golang build
	$(MAKE) -C pulumi build
	$(MAKE) -C packer build
	$(MAKE) -C maven build

release: ## Push docker image to docker hub
	$(MAKE) -C golang release
	$(MAKE) -C pulumi release
	$(MAKE) -C packer release
	$(MAKE) -C maven release

# Absolutely awesome: http://marmelab.com/blog/2016/02/29/auto-documented-makefile.html
help: ## Print this help.
	@grep -E '^[a-zA-Z._-]+:.*?## .*$$' $(MAKEFILE_LIST) | awk 'BEGIN {FS = ":.*?## "}; {printf "\033[36m%-30s\033[0m %s\n", $$1, $$2}'

agents:
	$(MAKE) -C golang agent
	$(MAKE) -C pulumi agent
	$(MAKE) -C packer agent
	$(MAKE) -C maven agent

logs:
	$(MAKE) -C golang logs
	$(MAKE) -C pulumi logs
	$(MAKE) -C packer logs
	$(MAKE) -C maven logs

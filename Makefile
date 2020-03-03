
VERSION=$(shell docker image inspect jenkinsci/jnlp-slave:latest | jq -r '.[0].ContainerConfig.Labels.Version')
export NAME=fr123k/jocker-agents-golang
export IMAGE="${NAME}:${VERSION}"
export LATEST="${NAME}:latest"

pull-base:  ## Push docker image to docker hub
	docker pull jenkinsci/jnlp-slave:latest

build: ## Build the jenkins in docker image.
	docker build -t $(IMAGE) -f Dockerfile .

release: ## Push docker image to docker hub
	docker tag ${IMAGE} ${LATEST}
	docker push ${NAME}

# Absolutely awesome: http://marmelab.com/blog/2016/02/29/auto-documented-makefile.html
help: ## Print this help.
	@grep -E '^[a-zA-Z._-]+:.*?## .*$$' $(MAKEFILE_LIST) | awk 'BEGIN {FS = ":.*?## "}; {printf "\033[36m%-30s\033[0m %s\n", $$1, $$2}'

agent: build
	docker run $(IMAGE) -url http://host.docker.internal:8080 $(shell curl -L -s http://admin:$(API_TOKEN)@localhost:8080/computer/docker-1/slave-agent.jnlp | sed "s/.*<application-desc main-class=\"hudson.remoting.jnlp.Main\"><argument>\([a-z0-9]*\).*/\1/") docker-1

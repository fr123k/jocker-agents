
VERSION=$(shell docker image inspect jenkinsci/jnlp-slave:latest | jq -r '.[0].ContainerConfig.Labels.Version')
export NAME=fr123k/jocker-agents-golang
export IMAGE="${NAME}:${VERSION}"
export LATEST="${NAME}:latest"

API_TOKEN=$(shell docker logs $(shell docker ps -f name=jocker -q) | grep 'Api-Token:' | tr ':' '\n' | tail -n +2)
DOCKER_HOST=$(shell ip -4 addr show docker0 | grep -Po 'inet \K[\d.]+')

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

agent:
	echo "API-Token: ${API_TOKEN}"
	docker run -d --name agent --rm $(IMAGE) -url http://$(DOCKER_HOST):8080 $(shell curl -L -s http://admin:$(API_TOKEN)@localhost:8080/computer/docker-1/slave-agent.jnlp | sed "s/.*<application-desc main-class=\"hudson.remoting.jnlp.Main\"><argument>\([a-z0-9]*\).*/\1/") docker-1

test:
	docker ps
	docker logs $(shell docker ps -f name=jocker -q)
	docker ps
	docker logs $(shell docker ps -f name=agent -q) || true
	./scripts/jenkins-wait.sh Jenkins/job/Setup
	@curl -s http://admin:$(API_TOKEN)@localhost:8080/job/Jenkins/job/SharedLib/lastBuild/consoleText
	@curl -s http://admin:$(API_TOKEN)@localhost:8080/job/Jenkins/job/Configure/lastBuild/consoleText
	@curl -s http://admin:$(API_TOKEN)@localhost:8080/job/Jenkins/job/Jobs/lastBuild/consoleText
	@curl -s http://admin:$(API_TOKEN)@localhost:8080/job/Jenkins/job/Setup/lastBuild/consoleText
	@curl -s http://admin:$(API_TOKEN)@localhost:8080/job/Jenkins/job/Setup/lastBuild/api/json | jq -r .result | grep SUCCESS

	docker logs $(shell docker ps -f name=agent -q)
	./scripts/jenkins-cli.sh pulumi $(API_TOKEN)
	@curl -s http://admin:$(API_TOKEN)@localhost:8080/job/pulumi/lastBuild/api/json | jq -r .result | grep SUCCESS

.PHONY: agents
API_TOKEN=$(shell docker logs $(shell docker ps -f name=jocker -q) | grep 'Api-Token:' | tr ':' '\n' | tail -n +2)
SEED_BRANCH_RAW=$(shell [ -z "${TRAVIS_PULL_REQUEST_BRANCH}" ] && echo "${TRAVIS_BRANCH}"|| echo "${TRAVIS_PULL_REQUEST_BRANCH}")
SEED_BRANCH=$(shell echo "${SEED_BRANCH_RAW}" | sed s/\\//\\%2F/g)

pull-base:  ## Push docker image to docker hub
	docker pull jenkinsci/jnlp-slave:latest

build: ## Build the jenkins agents as docker images.
	$(MAKE) -C agents build

release: ## Push docker image to docker hub
	$(MAKE) -C agents release

# Absolutely awesome: http://marmelab.com/blog/2016/02/29/auto-documented-makefile.html
help: ## Print this help.
	@grep -E '^[a-zA-Z._-]+:.*?## .*$$' $(MAKEFILE_LIST) | awk 'BEGIN {FS = ":.*?## "}; {printf "\033[36m%-30s\033[0m %s\n", $$1, $$2}'

jocker-ready:
	echo "API-Token: ${API_TOKEN}"
	./scripts/jenkins-wait.sh Jenkins/job/Setup
	sleep 30

agents:
	$(MAKE) -C agents agents

logs:
	$(MAKE) -C agents logs

test: logs
	docker ps -a
	docker logs $(shell docker ps -a -f name=jocker -q)
	./scripts/jenkins-wait.sh Jenkins/job/Setup
	@curl -s http://admin:$(API_TOKEN)@localhost:8080/job/Jenkins/job/SharedLib/lastBuild/consoleText
	@curl -s http://admin:$(API_TOKEN)@localhost:8080/job/Jenkins/job/Configure/lastBuild/consoleText
	@curl -s http://admin:$(API_TOKEN)@localhost:8080/job/Jenkins/job/Jobs/lastBuild/consoleText
	@curl -s http://admin:$(API_TOKEN)@localhost:8080/job/Jenkins/job/Setup/lastBuild/consoleText
	@curl -s http://admin:$(API_TOKEN)@localhost:8080/job/Jenkins/job/Setup/lastBuild/api/json | jq -r .result | grep SUCCESS

	@curl -s http://admin:$(API_TOKEN)@localhost:8080/job/Pulumi/indexing/consoleText

	./scripts/jenkins-cli.sh Pulumi/job/${SEED_BRANCH} $(API_TOKEN)
	@curl -s http://admin:$(API_TOKEN)@localhost:8080/job/Pulumi/job/${SEED_BRANCH}/lastBuild/api/json | jq -r .result | grep SUCCESS

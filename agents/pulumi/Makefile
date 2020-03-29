VERSION=$(shell docker image inspect jenkinsci/jnlp-slave:latest | jq -r '.[0].ContainerConfig.Labels.Version')
CONTAINER_NAME=pulumi-agent
export NAME=fr123k/jocker-agents-pulumi
export IMAGE="${NAME}:${VERSION}"
export LATEST="${NAME}:latest"

API_TOKEN=$(shell docker logs $(shell docker ps -f name=jocker -q) | grep 'Api-Token:' | tr ':' '\n' | tail -n +2)
JOCKER_HOST?=$(shell ip -4 addr show docker0 | grep -Po 'inet \K[\d.]+')
SEED_BRANCH_RAW=$(shell [ -z "${TRAVIS_PULL_REQUEST_BRANCH}" ] && echo "${TRAVIS_BRANCH}"|| echo "${TRAVIS_PULL_REQUEST_BRANCH}")
SEED_BRANCH=$(shell echo "${SEED_BRANCH_RAW}" | sed s/\\//\\%2F/g)

build: ## Build the jenkins in docker image.
	docker build --build-arg JOCKER_AGENTS_GOLANG_VERSION=$(VERSION) -t $(IMAGE) -f Dockerfile .

release: ## Push docker image to docker hub
	docker tag ${IMAGE} ${LATEST}
	docker push ${NAME}

# Absolutely awesome: http://marmelab.com/blog/2016/02/29/auto-documented-makefile.html
help: ## Print this help.
	@grep -E '^[a-zA-Z._-]+:.*?## .*$$' $(MAKEFILE_LIST) | awk 'BEGIN {FS = ":.*?## "}; {printf "\033[36m%-30s\033[0m %s\n", $$1, $$2}'

jocker-ready:
	echo "API-Token: ${API_TOKEN}"
	./scripts/jenkins-wait.sh Jenkins/job/Setup
	sleep 30

agent:
	curl http://admin:$(API_TOKEN)@localhost:8080/computer/pulumi-1/slave-agent.jnlp
	docker run -d --name $(CONTAINER_NAME) --rm $(IMAGE) -url http://$(JOCKER_HOST):8080 $(shell curl -L -s http://admin:$(API_TOKEN)@localhost:8080/computer/pulumi-1/slave-agent.jnlp | sed "s/.*<application-desc main-class=\"hudson.remoting.jnlp.Main\"><argument>\([a-z0-9]*\).*/\1/") pulumi-1
	docker logs `docker ps -q -f name=${CONTAINER_NAME}`

logs:
	docker logs `docker ps -q -f name=${CONTAINER_NAME}`

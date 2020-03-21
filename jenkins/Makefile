export IMAGE="fr123k/jocker"

SEED_BRANCH=$(shell [ -z "${TRAVIS_PULL_REQUEST_BRANCH}" ] && echo "${TRAVIS_BRANCH}"|| echo "${TRAVIS_PULL_REQUEST_BRANCH}")

jocker: ## Start the jenkins in docker container short jocker.
	docker pull ${IMAGE}
	docker run -d -e SEED_JOB_GIT_REPO=fr123k/jocker-agents -e SEED_JOB_GROOVY_FILE=jenkins/dsl/pipeline-jobs.groovy -e SEED_BRANCH_JOBS=${SEED_BRANCH} -e SEED_BRANCH_CONFIGURE=${SEED_BRANCH_CONFIGURE} -p 50000:50000 -p 8080:8080 --name jocker --rm ${IMAGE}

logs: ## Show the logs of the jocker container
	docker logs $(shell docker ps -f name=jocker -q) -f

# Absolutely awesome: http://marmelab.com/blog/2016/02/29/auto-documented-makefile.html
help: ## Print this help.
	@grep -E '^[a-zA-Z._-]+:.*?## .*$$' $(MAKEFILE_LIST) | awk 'BEGIN {FS = ":.*?## "}; {printf "\033[36m%-30s\033[0m %s\n", $$1, $$2}'

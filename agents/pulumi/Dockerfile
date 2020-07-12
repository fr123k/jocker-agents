ARG JOCKER_AGENTS_GOLANG_VERSION=4.0.1-1

FROM fr123k/jocker-agents-golang:${JOCKER_AGENTS_GOLANG_VERSION}

USER root

RUN apt-get update && \
    apt-get upgrade -y && \
    apt-get install -y make pwgen jq

USER jenkins

RUN curl -fsSL https://get.pulumi.com/ | sh && \
    pulumi version

WORKDIR ${HOME}

COPY --chown=jenkins main.go ${HOME}

RUN go build main.go && \
    ./main && \
    pulumi version

LABEL maintainer="frank.ittermann@yahoo.de"

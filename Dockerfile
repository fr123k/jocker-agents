ARG GO_VERSION=1.12

FROM golang:${GO_VERSION} as gosrc

FROM jenkinsci/jnlp-slave:latest

ENV HOME /home/jenkins

USER root

RUN apt-get update && \
    apt-get upgrade -y && \
    apt-get install -y make pwgen jq

USER jenkins

RUN curl -fsSL https://get.pulumi.com/ | sh
    
ARG GO_BASE_PATH=/usr/local/go

COPY --from=gosrc --chown=jenkins ${GO_BASE_PATH} ${GO_BASE_PATH}
COPY --from=gosrc --chown=jenkins /go ${HOME}

ENV GOPATH ${HOME}
ENV PATH "${GOPATH}/bin:${GO_BASE_PATH}/bin:${HOME}/.pulumi/bin:${PATH}"
ENV CGO_ENABLED 0

WORKDIR ${HOME}

COPY --chown=jenkins main.go ${HOME}

RUN go build main.go && \
    ./main

LABEL maintainer="info@mjslabs.com"

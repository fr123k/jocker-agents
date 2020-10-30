FROM jenkinsci/jnlp-slave:latest

ARG ARCH=linux_amd64
ARG PACKER_VERSION=1.6.4

USER root

#TODO remove curl
RUN apt-get update && \
    apt-get upgrade -y && \
    apt-get install -y make unzip

USER jenkins

# TODO: checksum checks
RUN curl -Lo /tmp/packer.zip https://releases.hashicorp.com/packer/${PACKER_VERSION}/packer_${PACKER_VERSION}_linux_amd64.zip \
    && ls -lha /tmp

USER root

RUN ls -lha /tmp && \
    unzip /tmp/packer.zip -d /tmp && \
    cp /tmp/packer /usr/local/bin/packer && \
    rm /tmp/packer.zip && \
    packer version

USER jenkins

RUN packer version
ENV HOME /home/jenkins

WORKDIR ${HOME}

LABEL maintainer="frank.ittermann@yahoo.de"

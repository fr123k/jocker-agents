ARG ARCH=linux_amd64
ARG PACKER_VERSION=1.5.5

FROM jenkinsci/jnlp-slave:latest


USER root

#TODO remove curl
RUN apt-get update && \
    apt-get upgrade -y && \
    apt-get install -y make unzip

USER jenkins

# TODO: checksum checks
# RUN curl -Lo /tmp/packer.zip https://releases.hashicorp.com/packer/${PACKER_VERSION}/packer_${PACKER_VERSION}_${ARCH}.zip && \
RUN curl -Lo /tmp/packer.zip https://releases.hashicorp.com/packer/1.5.5/packer_1.5.5_linux_amd64.zip

USER root

RUN unzip /tmp/packer.zip -d /tmp && \
    cp /tmp/packer /usr/local/bin/packer && \
    rm /tmp/packer.zip && \
    packer version

USER jenkins

RUN packer version
ENV HOME /home/jenkins

WORKDIR ${HOME}

LABEL maintainer="info@mjslabs.com"

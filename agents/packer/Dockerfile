FROM fr123k/jocker-agents-golang:latest AS packer-provisioner-goss

WORKDIR /tmp
RUN git clone https://github.com/fr123k/packer-provisioner-goss.git && \
    cd packer-provisioner-goss && \
    go build

FROM jenkinsci/jnlp-slave:latest


ARG ARCH=linux_amd64
ARG PACKER_VERSION=1.6.5

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
    mv /tmp/packer /usr/local/bin/packer && \
    packer version

COPY --from=packer-provisioner-goss /tmp/packer-provisioner-goss/packer-provisioner-goss /tmp

RUN mkdir -p /home/jenkins/.packer.d/plugins/ && \
    mv /tmp/packer-provisioner-goss /home/jenkins/.packer.d/plugins/

# RUN curl -fsSL https://goss.rocks/install | sh

USER jenkins

RUN packer version
ENV HOME /home/jenkins

WORKDIR ${HOME}

LABEL maintainer="frank.ittermann@yahoo.de"

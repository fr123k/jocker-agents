FROM jenkinsci/jnlp-slave:latest

ENV HOME /home/jenkins

USER root

RUN apt-get update && \
    apt-get upgrade -y && \
    apt-get install -y make

USER jenkins

WORKDIR ${HOME}

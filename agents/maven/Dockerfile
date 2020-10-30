ARG MVN_VERSION=3.6.3-jdk-8

FROM maven:${MVN_VERSION} as src

FROM jenkinsci/jnlp-slave:latest

ENV HOME /home/jenkins

USER root

RUN apt-get update && \
    apt-get upgrade -y && \
    apt-get install -y make


ENV MAVEN_HOME /usr/share/maven
ENV MAVEN_CONFIG "$USER_HOME_DIR/.m2"

COPY --from=src --chown=jenkins /usr/share/maven /usr/share/maven
COPY --from=src --chown=jenkins /usr/share/maven/ref/settings-docker.xml /usr/share/maven/ref/settings-docker.xml
RUN ln -s /usr/share/maven/bin/mvn /usr/bin/mvn

USER jenkins

WORKDIR ${HOME}

LABEL maintainer="frank.ittermann@yahoo.de"

RUN mvn --version

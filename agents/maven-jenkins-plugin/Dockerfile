FROM fr123k/jocker-agents-maven

WORKDIR /home/jenkins
ADD pom.xml ./pom.xml

RUN mvn --version && \
    mvn -B dependency:go-offline

RUN ls -lha .m2/

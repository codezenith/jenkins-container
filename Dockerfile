FROM jenkins/jenkins:lts


ENV JENKINS_HOME /var/jenkins_home
ENV KEYSTORE /var/lib/jenkins


ARG KST_PASS
ARG CERT
ARG DOCKER

# Set to default values
# https://github.com/jenkinsci/docker#setting-update-centers
ENV JENKINS_UC https://updates.jenkins.io
ENV JENKINS_UC_EXPERIMENTAL https://updates.jenkins.io/experimental
ENV JENKINS_INCREMENTALS_REPO_MIRROR https://repo.jenkins-ci.org/incrementals
ENV JENKINS_UC_DOWNLOAD $JENKINS_UC/download


ENV HTTPS_PORT 443
ENV JAVA_OPTS -Dhudson.footerURL=http://codezenith.com -Djava.util.logging.config.file=${JENKINS_HOME}/log.properties -Dpermissive-script-security.enabled=true
ENV JENKINS_OPTS --httpsPort=${HTTPS_PORT} --httpsKeyStore=${KEYSTORE}/keystore.jks --httpsKeyStorePassword=${KST_PASS}
ENV JENKINS_SLAVE_AGENT_PORT 5000


COPY cacerts/keystore.jks ${KEYSTORE}/
COPY executors.groovy /usr/share/jenkins/ref/init.groovy.d/executors.groovy
COPY log.properties ${JENKINS_HOME}/
COPY plugins.txt /usr/share/jenkins/ref/plugins.txt

USER root

ADD cacerts/*.crt /tmp/
ADD get-docker.sh /tmp

# Run conditional docker
RUN if [ "$CERT" = "true" ] ; then mv /tmp/*.crt /usr/local/share/ca-certificates/ && update-ca-certificates ; fi
RUN if [ "$DOCKER" = "true" ] ; then chmod +x /tmp/get-docker.sh && /bin/sh /tmp/get-docker.sh ; fi


# Install plugins defined in plugins.txt
RUN /usr/local/bin/install-plugins.sh < /usr/share/jenkins/ref/plugins.txt

EXPOSE ${HTTPS_PORT}
EXPOSE ${JENKINS_SLAVE_AGENT_PORT}

USER jenkins

ENTRYPOINT [ "/usr/local/bin/jenkins.sh" ]
FROM docker:18.06.0-ce-dind

MAINTAINER Citilink Team (devops@citilink.ru)

ENV BAMBOO_VERSION=6.6.2

ENV VM_OPTS="-Xmx1024m -Xms512m"

ENV DOWNLOAD_URL=https://packages.atlassian.com/maven-closedsource-local/com/atlassian/bamboo/atlassian-bamboo-agent-installer/${BAMBOO_VERSION}/atlassian-bamboo-agent-installer-${BAMBOO_VERSION}.jar
ENV BAMBOO_USER_HOME=/root
ENV BAMBOO_AGENT_HOME=${BAMBOO_USER_HOME}/bamboo-agent-home
ENV AGENT_JAR=${BAMBOO_USER_HOME}/atlassian-bamboo-agent-installer.jar
ENV UPDATE_CPAPABILITY_SCRIPT=${BAMBOO_USER_HOME}/bamboo-update-capability.sh
ENV SCRIPT_WRAPPER=${BAMBOO_USER_HOME}/runAgent.sh
ENV INIT_BAMBOO_CAPABILITIES=${BAMBOO_USER_HOME}/init-bamboo-capabilities.properties
ENV BAMBOO_CAPABILITIES=${BAMBOO_AGENT_HOME}/bin/bamboo-capabilities.properties

RUN apk add --no-cache bash \
        ca-certificates \
        curl \
        zip \
        supervisor \
        openjdk8 \
        wget && \
    wget --no-check-certificate -O ${AGENT_JAR} ${DOWNLOAD_URL} && \
    wget -O ${UPDATE_CPAPABILITY_SCRIPT} https://bitbucket.org/atlassian/bamboo-update-capability/raw/master/bamboo-update-capability.sh && \
    wget -O ${SCRIPT_WRAPPER} https://bitbucket.org/atlassian/docker-bamboo-agent-base/raw/master/runAgent.sh && \
    chmod +x ${BAMBOO_USER_HOME}/bamboo-update-capability.sh && \
    chmod +x ${SCRIPT_WRAPPER} && \
    mkdir -p ${BAMBOO_USER_HOME}/bamboo-agent-home/bin && \
    mkdir -p /var/log/supervisord && \
    wget -q -O /etc/apk/keys/sgerrand.rsa.pub https://alpine-pkgs.sgerrand.com/sgerrand.rsa.pub && \
    wget https://github.com/sgerrand/alpine-pkg-glibc/releases/download/2.28-r0/glibc-2.28-r0.apk && \
    apk add glibc-2.28-r0.apk && \
    rm glibc-2.28-r0.apk

RUN ${BAMBOO_USER_HOME}/bamboo-update-capability.sh "system.jdk.JDK 1.8" /usr/lib/jvm/java-1.8-openjdk/bin/java

ADD supervisord.conf /etc/supervisor/conf.d/supervisord.conf

CMD ["/usr/bin/supervisord", "-c", "/etc/supervisor/conf.d/supervisord.conf"]

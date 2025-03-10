FROM jenkins/jenkins:2.303.1-jdk11

USER root

COPY requirements.txt $REF/requirements.txt

RUN apt-get update && \
    apt-get install -y python3 python3-pip && \
    rm -rf /var/lib/apt/lists/* && \
    pip3 install -r $REF/requirements.txt

USER jenkins

COPY plugins.yaml $REF/plugins.yaml

RUN jenkins-plugin-cli --plugin-file $REF/plugins.yaml --view-all-security-warnings --latest true --verbose

COPY init.groovy.d/ $REF/init.groovy.d/

COPY --chown=jenkins:jenkins jcasc/defaults.yaml /cfg/jenkins.yaml
COPY jcasc/defaults.yaml $REF/defaults.yaml
COPY jcasc/jcasc-apply.py /usr/local/bin/jcasc-apply

# so we can run this in code build
VOLUME /var/lib/docker
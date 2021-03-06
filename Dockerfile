from ubuntu:latest
maintainer Dane Barentine
run apt-get update
run apt-get install -q -y git-core

# Install Java 7

run DEBIAN_FRONTEND=noninteractive apt-get install -q -y software-properties-common
run DEBIAN_FRONTEND=noninteractive apt-get install -q -y python-software-properties
run DEBIAN_FRONTEND=noninteractive apt-add-repository ppa:webupd8team/java -y
run apt-get update
run echo oracle-java8-installer shared/accepted-oracle-license-v1-1 select true | /usr/bin/debconf-set-selections
run DEBIAN_FRONTEND=noninteractive apt-get install oracle-java8-installer -y

# Install JIRA

run apt-get install -q -y curl
run curl -Lks https://www.atlassian.com/software/jira/downloads/binary/atlassian-jira-software-7.0.5-jira-7.0.5.tar.gz -o /root/jira.tar.gz
run /usr/sbin/useradd --create-home --home-dir /usr/local/jira --shell /bin/bash jira
run mkdir -p /opt/jira
run tar zxf /root/jira.tar.gz --strip=1 -C /opt/jira
run mkdir -p /opt/jira-home
run echo "jira.home = /opt/jira-home" > /opt/jira/atlassian-jira/WEB-INF/classes/jira-application.properties

# Launching Jira

workdir /opt/jira-home
run rm -f /opt/jira-home/.jira-home.lock
expose 8080:8080
cmd ["/opt/jira/bin/start-jira.sh", "-fg"]
FROM ubuntu:14.04

RUN apt-get update

#Runit
RUN DEBIAN_FRONTEND=noninteractive apt-get install -y runit
CMD /usr/sbin/runsvdir-start

#SSHD
RUN DEBIAN_FRONTEND=noninteractive apt-get install -y openssh-server && mkdir -p /var/run/sshd && \
    echo 'root:root' |chpasswd
RUN sed -i "s/session.*required.*pam_loginuid.so/#session    required     pam_loginuid.so/" /etc/pam.d/sshd
RUN sed -i "s/PermitRootLogin without-password/#PermitRootLogin without-password/" /etc/ssh/sshd_config

#Utilities
RUN DEBIAN_FRONTEND=noninteractive apt-get install -y vim less net-tools inetutils-ping curl git telnet nmap socat dnsutils netcat tree htop unzip sudo software-properties-common

#Install Oracle Java 7
RUN add-apt-repository ppa:webupd8team/java -y && \
    apt-get update && \
    echo oracle-java7-installer shared/accepted-oracle-license-v1-1 select true | /usr/bin/debconf-set-selections && \
    DEBIAN_FRONTEND=noninteractive apt-get install -y oracle-java7-installer

RUN curl http://www.bizdirusa.com/mirrors/apache/maven/maven-3/3.2.1/binaries/apache-maven-3.2.1-bin.tar.gz | tar xz
RUN ln -s /apache-maven-3.2.1/bin/mvn /usr/local/bin/mvn

#Ruby
RUN DEBIAN_FRONTEND=noninteractive apt-get install -y ruby1.9.1

#NodeJs
RUN curl http://nodejs.org/dist/v0.10.28/node-v0.10.28-linux-x64.tar.gz | tar xz
RUN mv node* node && \
    ln -s /node/bin/node /usr/local/bin/node && \
    ln -s /node/bin/npm /usr/local/bin/npm

#Provisioner requirements
RUN gem install rest-client net-scp

#Loom
RUN wget https://github.com/continuuity/loom/releases/download/0.9.7/loom-0.9.7-standalone.zip && \
    unzip loom*zip && \
    rm loom*zip
RUN mv loom* /opt/loom
RUN mkdir -p /var/log/loom

RUN mkdir -p /opt/loom/embedded/bin && \
    ln -s /usr/local/bin/node /opt/loom/embedded/bin/node && \
    ln -s /usr/bin/ruby /opt/loom/embedded/bin/ruby

#Hack Production config wants client-built path
RUN ln -s /opt/loom/ui/client /opt/loom/ui/client-built

#Add runit services
ADD sv /etc/service 

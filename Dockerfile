FROM ubuntu
 
RUN echo 'deb http://archive.ubuntu.com/ubuntu precise main universe' > /etc/apt/sources.list && \
    echo 'deb http://archive.ubuntu.com/ubuntu precise-updates universe' >> /etc/apt/sources.list && \
    apt-get update

#Runit
RUN DEBIAN_FRONTEND=noninteractive apt-get install -y runit 
CMD /usr/sbin/runsvdir-start

#SSHD
RUN DEBIAN_FRONTEND=noninteractive apt-get install -y openssh-server &&	mkdir -p /var/run/sshd && \
    echo 'root:root' |chpasswd

#Utilities
RUN DEBIAN_FRONTEND=noninteractive apt-get install -y vim less net-tools inetutils-ping curl git telnet nmap socat dnsutils netcat tree htop unzip sudo

#Install Oracle Java 7
RUN apt-get install -y python-software-properties && \
    add-apt-repository ppa:webupd8team/java -y && \
    apt-get update && \
    echo oracle-java7-installer shared/accepted-oracle-license-v1-1 select true | /usr/bin/debconf-set-selections && \
    apt-get install -y oracle-java7-installer

#Maven
RUN curl http://www.bizdirusa.com/mirrors/apache/maven/maven-3/3.2.1/binaries/apache-maven-3.2.1-bin.tar.gz | tar xz

#Ruby
RUN DEBIAN_FRONTEND=noninteractive apt-get install -y ruby1.9.1

#NodeJs
RUN curl http://nodejs.org/dist/v0.10.26/node-v0.10.26-linux-x64.tar.gz | tar xz
RUN mv node* node && \
    ln -s /node/bin/node /usr/local/bin/node && \
    ln -s /node/bin/npm /usr/local/bin/npm

#Provisioner requirements
RUN gem install rest-client net-scp

#Loom
RUN git clone http://github.com/continuuity/loom.git
RUN cd loom/standalone && \
    /apache-maven-3.2.1/bin/mvn clean 
RUN cd loom/standalone && \
    /apache-maven-3.2.1/bin/mvn -Dmaven.test.skip=true package assembly:single && \
    unzip target/loom-0.9.5-SNAPSHOT-standalone.zip && \
    mv loom-0.9.5-SNAPSHOT-standalone /opt/loom && \
    rm -rf target

#Hack Production config wants client-built path
RUN ln -s /opt/loom/ui/client /opt/loom/ui/client-built

#Configuration
ADD . /docker

#Runit Automatically setup all services in the sv directory
RUN for dir in /docker/sv/*; do chmod +x $dir/run $dir/log/run; ln -s $dir /etc/service/; done

ENV HOME /root
WORKDIR /root
EXPOSE 22

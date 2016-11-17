FROM centos:6
MAINTAINER pgleghorn@gmail.com
ARG ORACLE_USER
ARG ORACLE_PASSWORD
# comment
RUN yum -y install wget unzip sudo
RUN mkdir -p /vagrant
COPY config.sh /vagrant
COPY scripts /vagrant/scripts
# grab kits
RUN mkdir -p /kits
WORKDIR /kits
RUN . /vagrant/config.sh
RUN /vagrant/scripts/download.sh ${ORACLE_USER} ${ORACLE_PASSWORD} http://download.oracle.com/otn/nt/middleware/11g/111180/ofm_sites_generic_11.1.1.8.0_disk1_1of1.zip
RUN wget --progress=dot:mega -O apache-tomcat-7.0.62.tar.gz http://archive.apache.org/dist/tomcat/tomcat-7/v7.0.62/bin/apache-tomcat-7.0.62.tar.gz
RUN wget --progress=dot:mega -O jdk-8u102-linux-x64.tar.gz --no-check-certificate --no-cookies --header "Cookie: oraclelicense=accept-securebackup-cookie" http://download.oracle.com/otn-pub/java/jdk/8u102-b14/jdk-8u102-linux-x64.tar.gz
RUN wget --progress=bar:mega -O hsqldb_1_8_0_10.zip http://downloads.sourceforge.net/project/hsqldb/hsqldb/hsqldb_1_8_0/hsqldb_1_8_0_10.zip
RUN wget --progress=bar:mega -O p22093196_111180_Generic.zip https://raw.githubusercontent.com/pgleghorn/kits/master/p22093196_111180_Generic.zip
# install everything
RUN /vagrant/scripts/install.sh
RUN rm -rf /kits/*
USER oracle
CMD bash -l -c "/u00/tomcat/bin/catalina.sh run"

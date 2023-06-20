FROM ubuntu:latest

RUN apt-get update && apt-get upgrade -y

#Instalar JDK 11
RUN apt-get install -y openjdk-11-jdk

#Instalar version reciente de maven
RUN apt-get install -y maven

#Instalar wget
RUN apt-get install -y wget

#Instalar apache ant 1.10.x
RUN cd /tmp
RUN wget https://dlcdn.apache.org/ant/binaries/apache-ant-1.10.13-bin.tar.gz
RUN tar -xf apache-ant-1.10.13-bin.tar.gz -C /usr/local
RUN ln -s /usr/local/apache-ant-1.10.7/ /usr/local/ant
RUN echo "export ANT_HOME=/usr/local/ant\n export PATH=${ANT_HOME}/bin:${PATH}"

#Instalar Solr 8.
RUN cd $HOME
RUN wget https://downloads.apache.org/lucene/solr/8.11.2/solr-8.11.2.tgz
RUN tar xzf solr-8.11.2.tgz solr-8.11.2/bin/install_solr_service.sh --strip-components=2
RUN bash ./install_solr_service.sh solr-8.11.2.tgz

#Instalar Apache Tomcat
RUN useradd -m -U -d /opt/tomcat -s /bin/false tomcat
RUN cd /tmp
RUN wget https://dlcdn.apache.org/tomcat/tomcat-9/v9.0.76/bin/apache-tomcat-9.0.76.tar.gz
RUN tar -xf apache-tomcat-9.0.76.tar.gz -C /opt/tomcat/
RUN ln -s /opt/tomcat/apache-tomcat-9.0.76 /opt/tomcat/latest
RUN chown -R tomcat: /opt/tomcat

# Establecer variables de entorno para Tomcat
ENV CATALINA_HOME /opt/tomcat/apache-tomcat-9.0.76
ENV PATH $CATALINA_HOME/bin:$PATH

# Exponer el puerto 8080 para acceder a Tomcat
EXPOSE 8080

#Instalación de git
RUN apt-get update
RUN apt-get install -y git




#Ejecucion de tomcat como proceso principal de la imagen
CMD ["/opt/tomcat/apache-tomcat-9.0.76/bin/catalina.sh", "run"]
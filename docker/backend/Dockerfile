FROM ubuntu:latest

RUN apt-get update && apt-get upgrade -y

#Instalar JDK 11
RUN apt-get install -y openjdk-11-jdk

#Estableciendo JAVA_HOME
ENV JAVA_HOME=/usr/lib/jvm/java-11-openjdk-amd64/
RUN export JAVA_HOME

#Instalar version reciente de maven
RUN apt-get install -y maven

#Instalar wget y nano
RUN apt-get install -y wget
RUN apt-get install -y nano

#Instalar apache Ant 1.10.x
RUN cd /tmp && wget https://dlcdn.apache.org/ant/binaries/apache-ant-1.10.13-bin.tar.gz
RUN tar -xf /tmp/apache-ant-1.10.13-bin.tar.gz -C /usr/local
RUN ln -s /usr/local/apache-ant-1.10.13/ /usr/local/ant
#ENV ANT_HOME=/usr/local/ant
#RUN export ANT_HOME
#RUN export PATH=${ANT_HOME}/bin:${PATH}
ENV ANT_HOME /usr/local/ant
ENV PATH /usr/local/ant/bin:${PATH}

#Instalar Solr 8.
RUN cd $HOME
RUN wget https://downloads.apache.org/lucene/solr/8.11.2/solr-8.11.2.tgz
RUN tar xzf solr-8.11.2.tgz solr-8.11.2/bin/install_solr_service.sh --strip-components=2
RUN bash ./install_solr_service.sh solr-8.11.2.tgz

#Instalar Apache Tomcat
RUN useradd -m -U -d /opt/tomcat -s /bin/false tomcat
RUN cd /tmp && wget https://dlcdn.apache.org/tomcat/tomcat-9/v9.0.76/bin/apache-tomcat-9.0.76.tar.gz
RUN tar -xf /tmp/apache-tomcat-9.0.76.tar.gz -C /opt/tomcat/
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


#INSTALACION DE DSPACE CRIS
#Obteniendo el código fuente desde github
RUN cd /usr/local/src
RUN mkdir /usr/local/src/crisinstallation
RUN cd /usr/local/src/crisinstallation
RUN git clone https://github.com/4Science/DSpace.git --branch dspace-cris-7 /usr/local/src/crisinstallation/dspace-parent/

#Configuracion inicial dspace
RUN cd /usr/local/src/crisinstallation/dspace-parent
COPY local.cfg /usr/local/src/crisinstallation/dspace-parent/dspace/config/

#Creando directorio de instalacion 
RUN mkdir /dspace

#Construyendo con maven 
RUN cd /usr/local/src/crisinstallation/dspace-parent && mvn package -e

#RUN cd /usr/local/src/crisinstallation/dspace-parent/dspace/target/dspace-installer && ant fresh_install

#RUN cp -r /dspace/webapps/* $CATALINA_HOME/webapps/

#RUN /dspace/bin/dspace create-administrator



#Ejecucion de tomcat como proceso principal de la imagen
CMD ["/opt/tomcat/apache-tomcat-9.0.76/bin/catalina.sh", "run"]
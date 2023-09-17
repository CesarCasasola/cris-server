FROM ubuntu:latest

RUN apt-get update && apt-get upgrade -y

#Instalar wget, nano y otras utilidades
RUN apt-get install -y wget
RUN apt-get install -y nano
RUN apt-get install -y lsof
RUN apt-get install -y curl
RUN apt-get install -y gpg
RUN apt-get install -y lsb-core
RUN apt-get install -y git

#Instalar JDK 11
RUN apt-get install -y openjdk-11-jdk
#Estableciendo JAVA_HOME
ENV JAVA_HOME=/usr/lib/jvm/java-11-openjdk-amd64/
RUN export JAVA_HOME

#Instalar version reciente de maven
RUN apt-get install -y maven

#Cambio de contrasenia para root
RUN echo 'root:rdsp4c3' | chpasswd
#Creacion de grupo y usario dspace
RUN useradd -m -U -s /bin/bash dspace
RUN usermod -aG sudo dspace

#Instalar apache Ant 1.10.x
RUN apt-get install -y ant

#Instalar Solr 8.
USER dspace
RUN cd /home/dspace && wget https://downloads.apache.org/lucene/solr/8.11.2/solr-8.11.2.tgz
RUN cd /home/dspace && tar -xvzf solr-8.11.2.tgz
USER root
RUN cd /home/dspace && ./solr-8.11.2/bin/install_solr_service.sh solr-8.11.2.tgz -f
EXPOSE 8983
RUN service solr start

#Instalar Apache Tomcat
USER dspace
RUN cd /home/dspace && wget https://archive.apache.org/dist/tomcat/tomcat-9/v9.0.78/bin/apache-tomcat-9.0.78.tar.gz
RUN cd /home/dspace && tar -xzvf /home/dspace/apache-tomcat-9.0.78.tar.gz
RUN mv /home/dspace/apache-tomcat-9.0.78 /home/dspace/tomcat9
#Configurando variables de entrono para CATALINA_ENV
USER root
COPY ./conf_files/tomcat/setenv.sh /home/dspace/tomcat9/bin
RUN chown dspace:dspace /home/dspace/tomcat9/bin/setenv.sh
#Configurando el servidor tomcat
COPY ./conf_files/tomcat/server.xml /home/dspace/tomcat9/conf
RUN chown dspace:dspace /home/dspace/tomcat9/conf/server.xml
# Establecer variables de entorno para Tomcat
ENV CATALINA_HOME /home/dspace/tomcat9/
ENV PATH $CATALINA_HOME/bin:$PATH
# Exponer el puerto 8080 para acceder a Tomcat
EXPOSE 8080

# #INSTALACION DE DSPACE CRIS
# #Creando directorio de instalacion de dspace
USER root
RUN mkdir /dspace
RUN chown dspace:dspace /dspace

#Descarga de código fuente
USER dspace
RUN git clone https://github.com/4Science/DSpace.git --branch dspace-cris-7 /home/dspace/dspace-cris/
RUN cd /home/dspace/dspace-cris/ && git checkout dba77647f41555d1b67c1c70428489a44ccb2f5d
#Copiar archivo de configuración
COPY ./conf_files/dspace/local.cfg /home/dspace/dspace-cris/dspace/config/
#Compilar con maven
RUN cd /home/dspace/dspace-cris/ && mvn package

USER dspace
COPY ./init/init-install.sh /home/dspace/

# #Ejecucion de tomcat como proceso principal de la imagen
# CMD ["/home/dspace/tomcat9/bin/catalina.sh", "run"]
# CMD ["tail", "-f", "/dev/null"]
CMD ["bash", "/home/dspace/init-install.sh"]

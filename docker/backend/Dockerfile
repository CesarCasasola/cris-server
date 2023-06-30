FROM ubuntu:latest

RUN apt-get update && apt-get upgrade -y

#Instalar JDK 11
RUN apt-get install -y openjdk-11-jdk
#Estableciendo JAVA_HOME
ENV JAVA_HOME=/usr/lib/jvm/java-11-openjdk-amd64/
RUN export JAVA_HOME

#Instalar version reciente de maven
RUN apt-get install -y maven

#Instalar wget, nano y otras utilidad
RUN apt-get install -y wget
RUN apt-get install -y nano
RUN apt-get install -y lsof
RUN apt-get install -y curl
RUN apt-get install -y gpg
RUN apt-get update
RUN apt-get install -y lsb-core
RUN apt-get install -y git

#Cambio de contrasenia para root
RUN echo 'root:rdsp4c3' | chpasswd 
#Creacion de grupo y usario dspace
RUN useradd -m -U -s /bin/bash dspace
RUN usermod -aG sudo dspace

#Instalar apache Ant 1.10.x
RUN apt-get install -y ant
# RUN cd /tmp && wget https://dlcdn.apache.org/ant/binaries/apache-ant-1.10.13-bin.tar.gz
# RUN tar -xf /tmp/apache-ant-1.10.13-bin.tar.gz -C /usr/local
# RUN ln -s /usr/local/apache-ant-1.10.13/ /usr/local/ant
# ENV ANT_HOME /usr/local/ant
# ENV PATH /usr/local/ant/bin:${PATH}

#Instalacion de postgres
ENV DEBIAN_FRONTEND noninteractive
RUN curl https://www.postgresql.org/media/keys/ACCC4CF8.asc | gpg --dearmor -o /etc/apt/trusted.gpg.d/apt.postgresql.org.gpg
RUN echo "deb http://apt.postgresql.org/pub/repos/apt/ `lsb_release -cs`-pgdg main" > /etc/apt/sources.list.d/pgdg.list
RUN apt-get update
RUN apt-get install -y postgresql-13 postgresql-client-13
#Geographic area 2
#Country 63
#Archivos de configuracion y preparacion de bd
COPY ./conf_files/postgresql.conf /etc/postgresql/13/main/
COPY ./conf_files/pg_hba.conf /etc/postgresql/13/main/
COPY ./conf_files/init-config-db.sh /home/dspace/
#Arrancando servidor postgresql
RUN /etc/init.d/postgresql start
#IMPORTANTE, por alguna razon el servidor postgres parece no arrancar
#Preparando permisos de ejecucion para script que creará usuario y base de datos
RUN usermod -aG dspace postgres
RUN chmod +x /home/dspace/init-config-db.sh
# #Creando usuario y base de datos
# USER postgres
# RUN /home/dspace/init-config-db.sh


#Instalar Solr 8.
USER dspace
RUN cd /home/dspace && wget https://downloads.apache.org/lucene/solr/8.11.2/solr-8.11.2.tgz
RUN cd /home/dspace && tar -xvzf solr-8.11.2.tgz
USER root
RUN cd /home/dspace && ./solr-8.11.2/bin/install_solr_service.sh solr-8.11.2.tgz -f
EXPOSE 8983
RUN service solr start
#IMPORTANTE, por alguna razon el servidor solr se detiene al arrancar el contenedor


#Instalar Apache Tomcat
USER dspace
RUN cd /home/dspace && wget https://dlcdn.apache.org/tomcat/tomcat-9/v9.0.76/bin/apache-tomcat-9.0.76.tar.gz
RUN cd /home/dspace && tar -xzvf /home/dspace/apache-tomcat-9.0.76.tar.gz
RUN mv /home/dspace/apache-tomcat-9.0.76 /home/dspace/tomcat9
# RUN ln -s /home/dspace/tomcat9/apache-tomcat-9.0.76 /home/dspace/tomcat/latest
# RUN chown -R dspace:dspace /home/dspace/tomcat9 
#Configurando variables de entrono para CATALINA_ENV
USER root
COPY ./conf_files/setenv.sh /home/dspace/tomcat9/bin
RUN chown dspace:dspace /home/dspace/tomcat9/bin/setenv.sh
#Configurando el servidor tomcat
COPY ./conf_files/server.xml /home/dspace/tomcat9/conf
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
RUN chown dspace:dispace /dspace 

# #Obteniendo el código fuente desde github
# USER root
# RUN mkdir /usr/local/src/crisinstallation
# RUN chown tomcat /usr/local/src/crisinstallation
# USER dspace
# RUN git clone https://github.com/4Science/DSpace.git --branch dspace-cris-7 /usr/local/src/crisinstallation/dspace-parent/

# #Configuracion inicial dspace
# COPY ./conf_files/local.cfg /usr/local/src/crisinstallation/dspace-parent/dspace/config/

# #Construyendo con maven 
# USER dspace
# RUN cd /usr/local/src/crisinstallation/dspace-parent && mvn package -e


# #RUN cd /usr/local/src/crisinstallation/dspace-parent/dspace/target/dspace-installer && ant fresh_install

# #RUN cp -r /dspace/webapps/* $CATALINA_HOME/webapps/

# #RUN /dspace/bin/dspace create-administrator



# #Ejecucion de tomcat como proceso principal de la imagen
USER dspace
CMD ["/home/dspace/tomcat9/bin/catalina.sh", "run"]
#CMD ["tail", "-f", "/dev/null"]
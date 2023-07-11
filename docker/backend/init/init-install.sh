#!/bin/bash

#Arrancando el servidor de solr
echo -e 'rdsp4c3\n' | su root -c 'service solr start'

#Si el directorio de instalacion está vacío, se procede a instalar
if [ -z "$(ls -A /dspace)" ]; then

     cd /home/dspace/dspace-cris/dspace/target/dspace-installer && ant fresh_install
     /dspace/bin/dspace database migrate
     /dspace/bin/dspace database info
     cp -r /dspace/webapps/* /home/dspace/tomcat9/webapps/

     echo -e 'rdsp4c3\n' | su root -c 'cp -r /dspace/solr/* /var/solr/data/'
     echo -e 'rdsp4c3\n' | su root -c 'chown -R solr:solr /var/solr/data/'
     echo -e 'rdsp4c3\n' | su root -c 'service solr restart'
     #Arrancando tomcat para hacer el primer deploy
     /home/dspace/tomcat9/bin/catalina.sh run
else
     #Si la instalación se realizó, se hace un inicio simple de Tomcat
     /home/dspace/tomcat9/bin/startup.sh
fi


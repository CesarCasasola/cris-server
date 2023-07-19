FROM node:16.18.0

RUN apt update -y && apt upgrade -y
RUN apt install npm -y
RUN apt install git -y
RUN apt install nano -y


RUN npm install --global pm2

#Directorio provisional para guardar archivos de configuracion
RUN mkdir /home/conf_files

#Instalación de DSpace Angular
#Obtención del código fuente
RUN git clone https://github.com/4Science/dspace-angular.git --branch dspace-cris-7
#Instalación de dependencias
RUN cd dspace-angular && yarn install

#Para no exceder la memoria de node
ENV NODE_OPTIONS="--max-old-space-size=6000"

#Compilación de angular para produccion llegó a requerir > 5GB RAM
RUN cd /dspace-angular && yarn build:prod 
#Ubicando el código en directorio de despliegue (/dspace-ui-deploy)
RUN mkdir /dspace-ui-deploy
RUN cp -R /dspace-angular/dist/ /dspace-ui-deploy
#Directorio y rchivo de configuración
RUN mkdir /dspace-ui-deploy/config

COPY ./conf_files/config.prod.yml /dspace-ui-deploy/config/
COPY ./conf_files/dspace-ui.json   /dspace-ui-deploy/
COPY ./conf_files/package.json /dspace-angular/

EXPOSE 4000

CMD ["bash", "/home/conf_files/init/init.sh"]
# CMD ["tail", "-f", "/dev/null"]
# CMD ["pm2", "start", "/dspace-ui-deploy/dspace-ui.json"]
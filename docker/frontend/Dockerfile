FROM node:16.18.0

RUN apt update -y && apt upgrade -y
RUN apt install npm -y
RUN apt install git -y

# Yarn viene instalado en la imagen estandar de node
# RUN npm install --global yarn


RUN npm install --global pm2
RUN git clone https://github.com/4Science/dspace-angular.git

EXPOSE 4000
CMD ["tail", "-f", "/dev/null"]
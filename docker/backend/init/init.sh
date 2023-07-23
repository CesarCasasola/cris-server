#!/bin/bash

#Si el directorio de despliegue no está vacío, se arranca con pm2
if [ -n "$(ls -A /dspace-ui-deploy/dist)" ]; then
     
     #Arrancando la aplicación ui con pm2
     pm2 start /dspace-ui-deploy/dspace-ui.json
fi

tail -f /dev/null

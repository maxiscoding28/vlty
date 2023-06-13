#!/bin/bash
Green='\033[0;32m' 
Yellow='\033[1;33m'
Red='\033[0;31m' 
Color_Off='\033[0m'

if ! docker network inspect vaulty-net > /dev/null; then
    echo -e ${Red}You must create the network for vaulty first. Try running: \"docker network create vaulty-net --subnet 192.168.211.0/24\"${Color_Off}
else
if ! docker-compose -p agent up -d; then
    echo -e ${Red}docker-compose up step failed or was cancelled. Check the docker-compose.yml file.${Color_Off}
else
echo -e ${Green}Agent started${Color_Off}
fi
fi

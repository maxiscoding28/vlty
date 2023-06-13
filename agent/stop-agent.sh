#!/bin/bash
Green='\033[0;32m' 
Yellow='\033[1;33m'
Red='\033[0;31m' 
Color_Off='\033[0m'

docker-compose -p agent down

echo -e ${Green}Agent and approle files removed${Color_Off}
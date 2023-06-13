#!/bin/bash
Green='\033[0;32m' 
Yellow='\033[1;33m'
Red='\033[0;31m' 
Color_Off='\033[0m'


## Todo, check that env variables for AWS are set otherwise don't start

Dont_Init_Flag=$1
if ! docker network inspect vaulty-net > /dev/null; then
    echo -e ${Red}You must create the network for vaulty first. Try running: \"docker network create vaulty-net --subnet 192.168.211.0/24\"${Color_Off}
else
if ! docker-compose -p azure up -d; then
    echo -e ${Red}docker-compose up step failed or was cancelled. Check the docker-compose.yml file.${Color_Off}
else
if [[ "$Dont_Init_Flag" = "ni" ]]; then
    echo -e ${Yellow}The \"noinit\" argument was passed \'ni\'.${Color_Off}
    echo -e ${Green}The Vault containers are running${Color_Off}${Yellow} but vault was not initialized.${Color_Off}

elif [[ $# -eq 1 && $Dont_Init_Flag!=ni ]]; then
    echo -e ${Yellow}The argument passed to ./start-cluster wasn\'t recognized. Only \'ni\' is accepted.${Color_Off}
    docker-compose -p azure down
    echo -e ${Yellow}Please try again.${Color_Off}
    exit 0
else
    echo -e ${Yellow}Initializing azure cluster${Color_Off}
    sleep 2
    VAULT_ADDR=http://127.0.0.1:8224 vault operator init -format=json -recovery-shares=1 -recovery-threshold=1 | jq -r > ./init.json
    echo -e ${Yellow}Logging in with root token.${Color_Off}
    VAULT_ADDR=http://127.0.0.1:8224 vault login $(cat ./init.json| jq -r '.root_token')
fi
fi
fi
#!/bin/bash
Green='\033[0;32m' 
Yellow='\033[1;33m'
Red='\033[0;31m' 
Color_Off='\033[0m'

Cluster=${1:-v}


# Change this to env flag
Dont_Init_Flag=$2

if ! docker network inspect vaulty-net > /dev/null; then
# TODO IF VAULTY_NET DOESN"T EXISTS THEN CREATE IT
    echo -e ${Red}You must create the network for vaulty first. Try running: \"docker network create vaulty-net --subnet 192.168.211.0/24\"${Color_Off}
else
if ! docker-compose -p $Cluster -f $Cluster/docker-compose.yml up -d; then
    echo -e ${Red}docker-compose up step failed or was cancelled. Check the docker-compose.yml file.${Color_Off}
else
if [[ "$Dont_Init_Flag" = "ni" ]]; then
    echo -e ${Yellow}The \"noinit\" argument was passed \'ni\'.${Color_Off}
    echo -e ${Green}The Vault containers are running${Color_Off}${Yellow} but vault was not initialized.${Color_Off}

elif [[ $# -eq 2 && $Dont_Init_Flag!=ni ]]; then
    echo -e ${Yellow}The argument passed to ./start-cluster wasn\'t recognized. Only \'ni\' is accepted.${Color_Off}
    docker-compose -p v down
    echo -e ${Yellow}Please try again.${Color_Off}
    exit 1
else
    echo -e ${Yellow}Initializing $Cluster cluster${Color_Off}
    sleep 2

    if [ "$Cluster" = "v" ]; then
        nodeport1=8200
        nodeport2=8202
        nodeport3=8204
    elif [ "$Cluster" = "dr" ]; then
        nodeport1=8206
        nodeport2=8208
        nodeport3=8210
    elif [ "$Cluster" = "pr" ]; then
        nodeport1=8212
        nodeport2=8214
        nodeport3=8216
    else
        echo "Unknown cluster: $Cluster"
        exit 1
    fi
    VAULT_ADDR=http://127.0.0.1:$nodeport1 vault operator init -format=json -key-shares=1 -key-threshold=1 | jq -r > $Cluster/init.json
    echo -e ${Green}Cluster initialized. Init output saved to $Cluster/init.json${Color_Off}
    echo -e ${Yellow}Unsealing vault.${Color_Off}
    VAULT_ADDR=http://127.0.0.1:$nodeport1 vault operator unseal $(cat $Cluster/init.json| jq -r '.unseal_keys_b64[]')
    echo -e ${Green}Cluster unsealed.${Color_Off}
    echo -e ${Yellow}Logging in with root token.${Color_Off}
    VAULT_ADDR=http://127.0.0.1:$nodeport1 vault login $(cat $Cluster/init.json| jq -r '.root_token')
    echo -e ${Yellow}Unsealing standby nodes${Color_Off}
    sleep 2
    VAULT_ADDR=http://127.0.0.1:$nodeport2 vault operator unseal $(cat $Cluster/init.json| jq -r '.unseal_keys_b64[]')
    VAULT_ADDR=http://127.0.0.1:$nodeport3 vault operator unseal $(cat $Cluster/init.json| jq -r '.unseal_keys_b64[]')
    watch VAULT_ADDR=http://127.0.0.1:$nodeport1 vault operator members
fi
fi
fi
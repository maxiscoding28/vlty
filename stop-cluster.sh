#!/bin/bash
Red='\033[0;31m' 
Yellow='\033[1;33m'
Color_Off='\033[0m'

Cluster=${1:-v}


# Delete network env flag
# Change this to env flag
Retain_Data_Flag=$2

docker-compose -p $Cluster down -v

if [[ "$Retain_Data_Flag" = "keep" ]]; then
    echo -e ${Yellow}'"keep" flag was passed. Retaining cluster data'
else
    rm -rf /Users/maxwinslow/dev/vlty/$Cluster/data/data0/* /Users/maxwinslow/dev/vlty/$Cluster/data/data1/* /Users/maxwinslow/dev/vlty/$Cluster/data/data2/*
    rm -rf /Users/maxwinslow/dev/vlty/$Cluster/logs/vault*
    rm -f /Users/maxwinslow/dev/vlty/$Cluster/init.json
    touch /Users/maxwinslow/dev/vlty/$Cluster/logs/vault0.log /Users/maxwinslow/dev/vlty/$Cluster/logs/vault1.log /Users/maxwinslow/dev/vlty/$Cluster/logs/vault2.log
fi
echo -e ${Yellow}Removing files${Color_Off}
echo -e ${Red}Stopped v cluster${Color_Off}
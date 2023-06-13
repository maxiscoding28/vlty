#!/bin/bash
Red='\033[0;31m' 
Yellow='\033[1;33m'
Color_Off='\033[0m'

docker-compose -p transit down -v
rm -f ./init.json
rm -rf ./data/*
rm -rf logs/vault.log/*
echo -e ${Yellow}Removing files${Color_Off}
echo -e ${Red}Stopped transit node${Color_Off}
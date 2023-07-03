# Launch mysql container on same network as vault cluster
docker run --name mysql -p 3306:3306 --network=vaulty-net -e MYSQL_ROOT_PASSWORD=root -d mysql

# Shell into mysql
mysql -h 127.0.0.1 -u root -proot

# Create database
CREATE DATABASE animals;

# Seed database with data
USE animals;
CREATE TABLE dogs (
    id INT NOT NULL AUTO_INCREMENT primary key,
    dogName varchar(255) NOT NULL,
    favoriteToy varchar(255) NOT NULL,
    age int NOT NULL
);
INSERT INTO dogs (dogName, favoriteToy, age)VALUES ("rosie", "tennis ball", 16);
INSERT INTO dogs (dogName, favoriteToy, age)VALUES ("cooper", "blanket", 9);
INSERT INTO dogs (dogName, favoriteToy, age)VALUES ("cody", "chew toy", 3);
CREATE TABLE cats (
    id INT NOT NULL AUTO_INCREMENT primary key,
    catName varchar(255) NOT NULL,
    favoriteToy varchar(255) NOT NULL,
    age int NOT NULL
);
INSERT INTO cats (catName, favoriteToy, age)VALUES ("murphy", "mouse toy", 12);
INSERT INTO cats (catName, favoriteToy, age)VALUES ("oscar", "ball of yarn", 3);
INSERT INTO cats (catName, favoriteToy, age)VALUES ("penelope", "bird chaser", 4);

# Enable database secrets engine at path mysql
vault secrets enable -path=mysql database

# Set up config (need to grab ip address from docker network inspect vaulty-net)
vault write mysql/config/docker-mysql \
    plugin_name=mysql-database-plugin \
    connection_url="{{username}}:{{password}}@tcp(mysql:3306)/" \
    allowed_roles="cat-person" allowed_roles="dog-person" username=root password=root

# Create roles for access only to respective tables
vault write mysql/roles/cat-person \
    db_name=docker-mysql \
    creation_statements="CREATE USER '{{name}}'@'%' IDENTIFIED BY '{{password}}';GRANT SELECT ON animals.cats TO '{{name}}'@'%';" \
    default_ttl="1h"

vault write mysql/roles/dog-person \
    db_name=docker-mysql \
    creation_statements="CREATE USER '{{name}}'@'%' IDENTIFIED BY '{{password}}';GRANT SELECT ON animals.dogs TO '{{name}}'@'%';" \
    default_ttl="1h"

# Generate credentials
$(vault read mysql/creds/cat-person -format=json | jq -r '"mysql -h 127.0.0.1 -u " + .data.username + " -p" + .data.password')
$(vault read mysql/creds/dog-person -format=json | jq -r '"mysql -h 127.0.0.1 -u " + .data.username + " -p" + .data.password')

# Test
use animals;select * from cats;
use animals;select * from dogs;
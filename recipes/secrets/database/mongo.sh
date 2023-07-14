docker run -d -p 27017-27019:27017-27019 --network vaulty-net  --name mongodb mongo

mongo --host localhost --port 27017

# db.createUser(
# { user: "vault",
#   pwd: "vault",
#   roles:[{role: "userAdmin" , db: "vault-db"}]
# })

# use admin
# db.system.users.find()



vault secrets enable database

vault write database/config/my-mongodb-database \
    plugin_name=mongodb-database-plugin \
    allowed_roles="my-role" \
    connection_url="mongodb://{{username}}:{{password}}@mongodb:27017/vault-db" \
    username="vault" \
    password="vault"

vault write database/roles/my-role \
    db_name=my-mongodb-database \
    creation_statements='{ "db": "vault-db", "roles": [{ "role": "userAdmin" }] }' \
    revocation_statements='{ "db": "vault-db", "roles": [{ "role": "userAdmin" }] }' \
    default_ttl="5m" \
    max_ttl="5m"

 vault read database/creds/my-role
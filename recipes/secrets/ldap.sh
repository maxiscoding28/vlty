# Create LDAP server
docker run \
    --name openldap \
    --detach \
    --network vaulty-net \
	--env LDAP_ORGANISATION="Maxyorg" \
	--env LDAP_DOMAIN="vaulty.com" \
	--env LDAP_ADMIN_PASSWORD="admin" \
    osixia/openldap

sleep 5

# Seed 1st openldap server
cat <<EOF > ldapseed.ldif
dn: ou=maxyorg,dc=vaulty,dc=com
changetype: add
objectClass: organizationalunit
objectClass: top
ou: maxyorg
description: The maxy organization @ vaulty.com

dn: ou=users,dc=vaulty,dc=com
changetype: add
objectClass: organizationalunit
objectClass: top
ou: users
description: Users for the maxy organization

dn: cn=managers,ou=maxyorg,dc=vaulty,dc=com
changetype: add
objectClass: groupofnames
objectClass: top
cn: managers
member: cn=maxy,ou=users,dc=vaulty,dc=com
member: cn=kate,ou=users,dc=vaulty,dc=com

dn: cn=peasants,ou=maxyorg,dc=vaulty,dc=com
changetype: add
objectClass: groupofnames
objectClass: top
cn: peasants
member: cn=murphy,ou=users,dc=vaulty,dc=com
member: cn=becca,ou=users,dc=vaulty,dc=com

dn: cn=maxy,ou=users,dc=vaulty,dc=com
changetype: add
objectClass: person
objectClass: top
cn: maxy
sn: maxy
memberOf: cn=managers,ou=groups,dc=vaulty,dc=com
userPassword: 1234

dn: cn=kate,ou=users,dc=vaulty,dc=com
changetype: add
objectClass: person
objectClass: top
cn: kate
sn: kate
memberOf: cn=managers,ou=groups,dc=vaulty,dc=com
userPassword: 1234

dn: cn=becca,ou=users,dc=vaulty,dc=com
changetype: add
objectClass: person
objectClass: top
cn: becca
sn: becca
memberOf: cn=peasants,ou=groups,dc=vaulty,dc=com
userPassword: 1234

dn: cn=murphy,ou=users,dc=vaulty,dc=com
changetype: add
objectClass: person
objectClass: top
cn: murphy
sn: murphy
memberOf: cn=peasants,ou=groups,dc=vaulty,dc=com
userPassword: 1234
EOF

docker cp ./ldapseed.ldif openldap:/

docker exec -it openldap \
    ldapadd -x -w admin -D "cn=admin,dc=vaulty,dc=com" -f ldapseed.ldif

docker exec -it openldap sh

# Searches
ldapsearch -x -H ldap://localhost -b dc=vaulty,dc=com -D "cn=admin,dc=vaulty,dc=com" -w admin "(objectClass=*)"
ldapsearch -x -H ldap://localhost -b dc=vaulty,dc=com -D "cn=admin,dc=vaulty,dc=com" -w admin "(objectClass=organizationalunit)"
ldapsearch -x -H ldap://localhost -b dc=vaulty,dc=com -D "cn=admin,dc=vaulty,dc=com" -w admin "(objectClass=groupofnames)"
ldapsearch -x -H ldap://localhost -b dc=vaulty,dc=com -D "cn=admin,dc=vaulty,dc=com" -w admin "(cn=managers)" member
ldapsearch -x -H ldap://localhost -b dc=vaulty,dc=com -D "cn=admin,dc=vaulty,dc=com" -w admin "(cn=peasants)" member

vault auth enable ldap

vault write auth/ldap/config \
    url="ldap://openldap" \
    userdn="ou=users,dc=vaulty,dc=com" \
    groupdn="ou=maxyorg,dc=vaulty,dc=com" \
    groupfilter="(|(memberUid={{.Username}})(member={{.UserDN}})(uniqueMember={{.UserDN}}))" \
    groupattr="cn" \
    starttls=false \
    binddn="cn=admin,dc=vaulty,dc=com" \
    bindpass="admin"


vault write -f auth/ldap/users/maxy
vault write -f auth/ldap/users/kate
vault write -f auth/ldap/users/becca
vault write -f auth/ldap/users/murphy


vault login -method=ldap username=maxy password=1234
vault login -method=ldap username=kate password=1234
vault login -method=ldap username=becca password=1234
vault login -method=ldap username=murphy password=1234


### Not Scripted ###
# Log in as root
####################


LDAP_ACCESSOR=$(vault auth list -format=json | jq -r '.["ldap/"].accessor')

MANAGERS_GROUP_ID=$(vault write -format=json identity/group \
    name="managers" \
    type="external" \
    policies="admin" | jq -r '.data.id')

vault write identity/group-alias name="managers" \
     mount_accessor=$LDAP_ACCESSOR \
     canonical_id=$MANAGERS_GROUP_ID

PEASANTS_GROUP_ID=$(vault write -format=json identity/group \
    name="peasants" \
    type="external" \
    policies="viewer" | jq -r '.data.id')

vault write identity/group-alias name="peasants" \
     mount_accessor=$LDAP_ACCESSOR \
     canonical_id=$PEASANTS_GROUP_ID

vault login -method=ldap username=maxy password=1234
vault login -method=ldap username=kate password=1234
vault login -method=ldap username=becca password=1234
vault login -method=ldap username=murphy password=1234

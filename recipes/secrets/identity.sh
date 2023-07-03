# Create base policies
vault policy write entity-policy - <<EOF
path "kv/data/base" {
   capabilities = ["create", "read"]
}
EOF

vault policy write upass1-alias-policy - <<EOF
path "kv/data/upass1" {
   capabilities = ["create", "read"]
}
EOF

vault policy write upass2-alias-policy - <<EOF
path "kv/data/upass2" {
   capabilities = [ "create", "read", "update", "delete" ]
}
EOF

# Enable auth methods
vault auth enable -path=upass1 userpass
vault auth enable -path=upass2 userpass

# Create users on auth method with policy
vault write auth/upass1/users/max1 password=1234 token_policies=upass1-alias-policy
vault write auth/upass2/users/max2 password=1234 token_policies=upass2-alias-policy

# Create entity
ENTITY_ID=$(vault write -field=id identity/entity name=max-winslow policies=entity-policy)

MOUNT_ACCESSOR1=$(vault auth list -format=json | jq -r '."upass1/" | .accessor')
MOUNT_ACCESSOR2=$(vault auth list -format=json | jq -r '."upass2/" | .accessor')


# Create entity aliases
ALIAS_ID=$(vault write -field=id identity/entity-alias name=max1 canonical_id=$ENTITY_ID mount_accessor=$MOUNT_ACCESSOR1)
vault write identity/entity-alias name=max2 canonical_id=$ENTITY_ID mount_accessor=$MOUNT_ACCESSOR2

# Attempt login, confirm all policies are associated
vault login -path=upass1 -method=userpass -no-store=true username=max1 password=1234
vault login -path=upass2 -method=userpass -no-store=true username=max2 password=1234

# Create group policies
vault policy write internal-group-policy - <<EOF
path "kv/data/internal-group" {
capabilities = [ "create", "read", "update", "delete", "list", "sudo", "patch" ]
}
EOF

# Create group policy
vault policy write external-group-policy - <<EOF
path "kv/data/external-group" {
capabilities = [ "create", "read", "update", "delete", "list", "sudo", "patch" ]
}
EOF

# Create internalgroup
vault write identity/group name="internal-group" policies=internal-group-policy member_entity_ids=$ENTITY_ID

# Attempt login, confirm all policies are associated
vault login -path=upass1 -method=userpass -no-store=true username=max1 password=1234
vault login -path=upass2 -method=userpass -no-store=true username=max2 password=1234

# Enable github
vault auth enable github

# Configure organization
vault write auth/github/config organization=maxypoo-org

# List auth mounts (w/ accessor)
vault auth list
GITHUB_ACCESSOR=$(vault auth list -format=json | jq -r '."github/" | .accessor')

# Create external group
GROUP_ID=$(vault write -field=id identity/group name=external-group policies=external-group-policy type=external)

# Create group-alias
vault write identity/group-alias name=maxypoo-team mount_accessor=$GITHUB_ACCESSOR canonical_id=$GROUP_ID

# Github token must have org:read scope
vault login -method=github
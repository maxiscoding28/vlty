# Create policies
vault policy write viewer - <<EOF
path "kv/data/max" {
    capabilities = [ "read" ]
    control_group = {
        factor "approvers" {
            identity {
                group_names = ["manager-group" ]
                approvals = 1
            }
        }
    }
}
EOF
vault policy write admin - <<EOF
# Manage k/v secrets
path "*" {
    capabilities = ["create", "read", "update", "delete", "list"]
}
EOF
vault policy write group - <<EOF
# Manage k/v secrets
path "*" {
    capabilities = ["create", "read", "update", "delete", "list"]
}
EOF

# Enable user pass and grab accessor
vault auth enable userpass
MOUNT_ACCESSOR=$(vault auth list -format=json | jq -r '."userpass/".accessor')

# Create IC user trying to view secret
vault write auth/userpass/users/ic token_policies=viewer password=1234

# Create secret
vault secrets enable -version=2 kv
vault kv put kv/max password=1234

# Create manager with entity id and add to group manager-group
ENTITY_ID=$(vault write identity/entity name=manager policies=admin -format=json | jq -r '.data.id')

vault write auth/userpass/users/manager password=1234

vault write identity/entity-alias name=manager canonical_id=$ENTITY_ID mount_accessor=$MOUNT_ACCESSOR

vault write identity/group name=manager-group type=internal member_entity_ids=$ENTITY_ID policies=group

# Confirm manager has group policy from group and admin policy from manager entity
vault login -method=userpass username=manager password=1234


# Login as IC and try to read on control groups path
vault login -method=userpass username=ic password=1234

# Grab accessor from get request
vault kv get -format=json kv/max | jq

# Attempt to unwrap token (should fail)
vault unwrap $TOKEN
# Error unwrapping: Error making API request.
# URL: PUT http://127.0.0.1:8200/v1/sys/wrapping/unwrap
# Code: 400. Errors:
# * Request needs further authorization

# Login as manager in UI

# Copy/paste accessor into Access > Control Groups. Authorize

# Re-attempt to unwrap as IC (should succeed)
vault unwrap $TOKEN




# Enable approle and create role
vault auth enable approle
vault write -f auth/approle/role/agent

# Get role-id and secre-it
export ROLE_ID=$(vault read -field=role_id auth/approle/role/agent/role-id)
export SECRET_ID=$(vault write -f -field=secret_id auth/approle/role/agent/secret-id)

vault policy write agent - <<EOF
# Read permission on the k/v secrets
path "*" {
    capabilities = ["read", "create", "update"]
}
path "auth/token/lookup-self" {
  capabilities = ["read"]
}
EOF

vault write auth/approle/role/agent token_policies=agent 

vault write auth/approle/role/agent token_ttl=5s token_max_ttl=30m token_policies=agent

vault secrets enable -version=2 kv

vault kv put kv/pass max=1234

echo $ROLE_ID > /Users/mauriciolombard/vlty/agent/role-id
echo $SECRET_ID > /Users/mauriciolombard/vlty/agent/secret-id
vault kv put kv/pass pass=abc

vault auth enable jwt

vault policy write jwt-reader - <<EOF
path "kv/data/pass" {
  capabilities = ["read"]
}
EOF

VAULT_TOKEN=$(vault token create -policy=jwt-reader -field=token) vault kv get kv/pass
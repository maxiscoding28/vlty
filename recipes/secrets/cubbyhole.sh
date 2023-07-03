# Create token create policy
vault policy write token-creator - <<EOF
path "auth/token/create" {
  capabilities = ["create", "update"]
}
EOF

# Create default token and login
TOKEN=$(vault token create -policy=token-creator -field=token)
vault login $TOKEN

# Write and read back from cubbyhole
## Only this token can access path
vault write cubbyhole/max pass=1234
WRAPPING_TOKEN=$(vault read -wrap-ttl=5m -field=wrapping_token cubbyhole/max)

# As root, get wrap token for kv path, and lookup
## Token only has 1 use and response-wrapping policy
TOKEN=$(vault token create -policy=default -field=token)
vault login $TOKEN

# Should fail
vault read cubbyhole/max

# Login as default token. Unwrap token
vault unwrap $WRAPPING_TOKEN
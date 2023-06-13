# Run on the V cluster
vault secrets enable transit

vault write -f transit/keys/autounseal

vault policy write unseal-policy - <<EOF
path "transit/encrypt/autounseal" {
  capabilities = ["update"]
}
path "transit/decrypt/autounseal" {
  capabilities = ["update"]
}
path "transit/keys" {
  capabilities = ["list"]
}
path "transit/keys/autounseal" {
  capabilities = ["read"]
}
EOF

export VAULT_TOKEN=$(vault token create -field=token -orphan -policy="unseal-policy" -period=24h)

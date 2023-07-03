vault policy write access-yz-namespaces - <<EOF
# Manage k/v secrets
path "y/sys/auth" {
  capabilities = ["read"]
}
path "z/sys/auth" {
  capabilities = ["read"]
}
EOF

vault namespace create y
vault namespace create z

vault login $(vault token create -field=token -policy=access-yz-namespaces)

vault auth list -namespace=y
vault auth list -namespace=z
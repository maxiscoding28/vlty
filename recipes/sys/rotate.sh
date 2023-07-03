vault policy write rotate-policy - <<EOF
path "sys/rotate" {
   capabilities = ["update", "sudo"]
}
path "sys/key-status" {
   capabilities = ["read"]
}
EOF

vault login $(vault token create -policy=rotate-policy -field=token)

vault operator rotate
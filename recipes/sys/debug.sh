# Policy for debug
vault policy write debug - <<EOF
path "auth/token/lookup-self" {
  capabilities = ["read"]
}
path "sys/pprof/*" {
  capabilities = ["read"]
}
path "sys/config/state/sanitized" {
  capabilities = ["read"]
}
path "sys/monitor" {
  capabilities = ["read"]
}
path "sys/host-info" {
  capabilities = ["read"]
}
path "sys/in-flight-req" {
  capabilities = ["read"]
}
EOF

vault login $(vault token create -policy=debug -field=token)
filename=$(ls | grep vault-debug | awk '{print $NF}')
echo $filename
tar xvfz $filename
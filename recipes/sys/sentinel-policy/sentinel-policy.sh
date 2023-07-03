vault policy write viewer - <<EOF
path "kv/data/max" {
capabilities = [ "read" ]
}
EOF

vault secrets enable -version=2 kv

vault kv put kv/max pass=1234

EGP_POLICY=$(cat /Users/maxwinslow/support-repos/vaulty/recipes/sys/sentinel-policy/egp.sentinel | base64)

vault write sys/policies/egp/weekends-only \
      policy="${EGP_POLICY}" \
      paths="auth/userpass/*" \
      enforcement_level="hard-mandatory"

RGP_POLICY=$(cat /Users/maxwinslow/support-repos/vaulty/recipes/sys/sentinel-policy/rgp.sentinel | base64)

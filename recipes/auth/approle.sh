vault auth enable approle

vault write auth/approle/role/max \
  token_policies=admin \
  token_ttl=1h \
  token_max_ttl=24h

ROLE_ID=$(vault read -field=role_id auth/approle/role/max/role-id)

SECRET_ID=$(vault write -f -field=secret_id auth/approle/role/max/secret-id)

vault write auth/approle/login role_id=$ROLE_ID secret_id=$SECRET_ID
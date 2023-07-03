### Not Scripted ###
# Sign up for Auth0 and get the following values for setup
export AUTH0_DOMAIN=
export AUTH0_CLIENT_ID=
export AUTH0_CLIENT_SECRET=
# Add the following URLs into the "Allowed Callback URLs"
# https://localhost:8250/oidc/callback, ttps://localhost:8200/ui/vault/auth/oidc/oidc/callback
####################

# Setup policies
vault policy write manager - <<EOF
# Manage k/v secrets
path "/secret/*" {
    capabilities = ["create", "read", "update", "delete", "list"]
}
EOF

vault policy write reader - <<EOF
# Read permission on the k/v secrets
path "/secret/*" {
    capabilities = ["read", "list"]
}
EOF

# Enable and configure oidc auth method
vault auth enable oidc
vault write auth/oidc/config \
         oidc_discovery_url="https://$AUTH0_DOMAIN/" \
         oidc_client_id="$AUTH0_CLIENT_ID" \
         oidc_client_secret="$AUTH0_CLIENT_SECRET" \
         default_role="reader"
vault write auth/oidc/role/reader \
      bound_audiences="$AUTH0_CLIENT_ID" \
      allowed_redirect_uris="http://localhost:8200/ui/vault/auth/oidc/oidc/callback" \
      allowed_redirect_uris="http://localhost:8250/oidc/callback" \
      allowed_redirect_uris="http://max.com:8250/oidc/callback" \
      allowed_redirect_uris="https://max.com:8259/oidc/callback" \
      user_claim="sub" \
      verbose_oidc_logging=true \
      policies="reader"

# Login with the new auth method
vault login -method=oidc role="reader"

vault write auth/oidc/role/kv-mgr \
         bound_audiences="$AUTH0_CLIENT_ID" \
	     allowed_redirect_uris="http://localhost:8200/ui/vault/auth/oidc/oidc/callback" \
         allowed_redirect_uris="http://localhost:8250/oidc/callback" \
         allowed_redirect_uris="https://max.com:8259/oidc/callback" \
         user_claim="sub" \
		 groups_claim="https://example.com/roles" \
         policies="" \
         verbose_oidc_logging=true 

vault write identity/group name="manager" type="external" \
         policies="manager" \
         metadata=responsibility="Manage K/V Secrets"
GROUP_ID=$(vault read -field=id identity/group/name/manager)
OIDC_AUTH_ACCESSOR=$(vault auth list -format=json  | jq -r '."oidc/".accessor')
vault write identity/group-alias name="kv-mgr" \
         mount_accessor="$OIDC_AUTH_ACCESSOR" \
         canonical_id="$GROUP_ID"

vault login -method=oidc role="kv-mgr"

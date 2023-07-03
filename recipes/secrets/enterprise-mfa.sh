# Enable userpass and add user
vault auth enable userpass
vault write auth/userpass/users/max password=1234

# Enable KV and add entry
vault secrets enable -version=2 kv
vault kv put kv/db pass=root

# Create policy with MFA
vault write sys/mfa/method/duo/duo-kv-read \
    mount_accessor=auth_userpass_1d544cef \
    secret_key=$DUO_SECRET_KEY \
    integration_key=$DUO_INTEGRATION_KEY \
    api_hostname=$DUO_API_HOSTNAME

# Read it back
vault read sys/mfa/method/duo/duo-kv-read

# Create MFA policy to secret
vault policy write mfa-read - <<EOF
path "/kv/data/db" {
  capabilities = ["read"]
	mfa_methods  = ["duo-kv-read"]
}
EOF

# Associate policy with user
vault write auth/userpass/users/max token_policies=mfa-read

# Login
vault login -method=userpass username=max password=1234

# Attempt to get kv secret and prompt with MFA (user must be enrolled)
vault kv get kv/db
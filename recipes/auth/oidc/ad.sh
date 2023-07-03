
# https://hashicorp.atlassian.net/wiki/spaces/VSE/pages/1199669570/OIDC+Auth+Method+with+Azure+Active+Directory

### Not Scripted ###
# Request Azure Subscription (temporary) via Doormat
####################

### Not Scripted ###
# Grab tenant ID
# Register an application
# Add redirect uris
# Grab application (client ID) for app registration
# Generate a secret and save value
####################
export TENANT_ID=
export APPLICATION_ID=
export APPLICATION_SECRET=

export CALLBACK_1="http://localhost:8250/oidc/callback"
export CALLBACK_2="http://localhost:8200/ui/vault/auth/oidc/oidc/callback"

vault write auth/oidc/config \
oidc_discovery_url="https://login.microsoftonline.com/$TENANT_ID/v2.0" \
oidc_client_id=$APPLICATION_ID \
oidc_client_secret=$APPLICATION_SECRET \
default_role="reader"

vault write auth/oidc/role/reader \
bound_audiences=$APPLICATION_ID \
allowed_redirect_uris=$CALLBACK_1 \
allowed_redirect_uris=$CALLBACK_2 \
user_claim="sub" \
policies="default"
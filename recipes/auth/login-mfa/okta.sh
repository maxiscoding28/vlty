### Not Scripted ###
# Security > API > Tokens
# Create token (any name) and copy
export OKTA_TOKEN=""
# Select dropdown top right with username
# Copy org name (part before .okta.com)
export OKTA_ORG=""

export OKTA_USERNAME=""
export OKTA_PASSWORD=""
####################

vault auth enable okta
vault write auth/okta/config \
   org_name="$OKTA_ORG" \
   api_token="$OKTA_TOKEN"

vault write auth/okta/config \
   bypass_okta_mfa=true \
   org_name="$OKTA_ORG" \
   api_token="$OKTA_TOKEN"

MFA_METHOD=$(vault write /identity/mfa/method/okta org_name=$OKTA_ORG api_token=$OKTA_TOKEN base_url=okta.com username_format="admin@admin.com" -format=json | jq -r '.data.method_id')

ACCESSOR=$(vault auth list --detailed -format=json | jq -r '.["okta/"].accessor')

vault write /identity/mfa/login-enforcement/okta-mfa mfa_method_ids=$MFA_METHOD auth_method_accessors=$ACCESSOR

vault login -method=okta username=$OKTA_USERNAME password=$OKTA_PASSWORD
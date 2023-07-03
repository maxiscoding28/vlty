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

vault login -method=okta username=$OKTA_USERNAME password=$OKTA_PASSWORD
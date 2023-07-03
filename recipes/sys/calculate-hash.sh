# enable logs
vault audit enable file file_path=/vault/logs/vault0.log

# Trigger request and grab client token and access
CLIENT_TOKEN=$(vault token lookup -format=json | jq -r '.data.id')
ACCESSOR=$(vault token lookup -format=json | jq -r '.data.accessor')

### Not Scripted ###
# - Grab hmac'ed values from audit log
# - Example: tail -f v/logs/vault0.log | jq -r 'select(.type == "response") | "Client token: \(.auth.client_token)\nAccessor: \(.response.data.accessor)"'
# - CLIENT_TOKEN_HMAC
# - ACCESSOR_HMAC
####################
CLIENT_TOKEN_HMAC=""
ACCESSOR_HMAC=""

# Lookup using /audit-hash
EXPECTED_CLIENT_TOKEN_HMAC=$(vault write /sys/audit-hash/file input=$CLIENT_TOKEN -format=json | jq -r '.data.hash')
EXPECTED_ACCESSOR_HMAC=$(vault write /sys/audit-hash/file input=$ACCESSOR -format=json | jq -r '.data.hash')

# Check if they are equal
[ "$EXPECTED_CLIENT_TOKEN_HMAC" = "$CLIENT_TOKEN_HMAC" ] && echo "Client hashes match" || echo "Client hashes don't match"
[ "$EXPECTED_ACCESSOR_HMAC" = "$ACCESSOR_HMAC" ] && echo "Accessor hashes match" || echo "Accessor hashes don't match"


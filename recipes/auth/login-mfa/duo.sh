### Not Scripted ###
# Set up DUO MFA
CLIENT_ID=
CLIENT_SECRET=
HOST_NAME=
####################

vault auth enable userpass
MOUNT_ACCESSOR=$(vault auth list -format=json | jq -r '.["userpass/"].accessor')
vault write auth/userpass/users/max password=1234

vault login -method=userpass username=max password=1234

METHOD_ID=$(vault write identity/mfa/method/duo integration_key=$CLIENT_ID secret_key=$CLIENT_SECRET api_hostname=$HOST_NAME username_format="" use_passcode=true -format=json | jq -r '.data.method_id')
vault read identity/mfa/method/duo/$METHOD_ID
vault write identity/mfa/login-enforcement/duo mfa_method_ids=$METHOD_ID auth_method_accessors=$MOUNT_ACCESSOR

vault login -method=userpass username=max password=1234

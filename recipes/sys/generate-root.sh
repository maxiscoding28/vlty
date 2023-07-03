###### INPUTS ######
echo "Input your unseal key"
read UNSEAL_KEY
####################

vault operator generate-root -init -format=json > generate-root.json
NONCE=$(cat generate-root.json | jq -r '.nonce')
OTP=$(cat generate-root.json | jq -r '.otp')

# IF you need to cancel
# vault operator generate-root -cancel

ENCODED_ROOT_TOKEN=$(vault operator generate-root -format=json -nonce=$NONCE $UNSEAL_KEY | jq -r '.encoded_root_token')

echo "encoded token: $ENCODED_ROOT_TOKEN"

ROOT_TOKEN=$(vault operator generate-root -otp=$OTP -decode=$ENCODED_ROOT_TOKEN -format=json | jq -r '.token')

echo "unenoded token: $ROOT_TOKEN"

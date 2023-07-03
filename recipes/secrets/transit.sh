# Enable transit
vault secrets enable transit

# Generate key
vault write -f transit/keys/max

# Read key
vault read transit/keys/max

# Rotate key
vault write -f transit/keys/max/rotate

# Encrypt data
## Base64 Text
PLAINTEXT=$(base64 <<< "I am secret text")

#Encrypt
CIPHERTEXT=$(vault write -field=ciphertext transit/encrypt/max plaintext=$PLAINTEXT)
# Rewrap data
## Rotate again
vault write -f transit/keys/max/rotate

## Rewrap
CIPHERTEXT=$(vault write -field=ciphertext transit/rewrap/max \
    ciphertext=$CIPHERTEXT)

# Decrypt
PLAINTEXT=$(vault write -field=plaintext transit/decrypt/max ciphertext=$CIPHERTEXT)

## Encrypt with v1
vault write transit/encrypt/max key_version=1 plaintext=$PLAINTEXT

## Decrypt v1 ciphertext
vault write -field=plaintext transit/decrypt/max ciphertext=$CIPHERTEXT | base64 -d

# Rotate again
vault write -f transit/keys/max/rotate

## Set min_decrypt and encrypt on key config
vault write transit/keys/max/config min_decryption_version=4 min_encryption_version=4

## Attempt same encrypt/decrypt operations (shoud fail)
vault write -field=plaintext transit/decrypt/max ciphertext=$CIPHERTEXT | base64 -d
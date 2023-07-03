### Not Scripted ###
UNSEAL_KEY=
####################

NONCE=$(vault operator rekey -init -key-shares=1 -key-threshold=1 -format=json | jq -r '.nonce')

# Repeat for each unseal key
vault operator rekey -nonce=$NONCE $UNSEAL_KEY

# If you need to cancel
vault operator rekey -cancel
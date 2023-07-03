##### PRE-REQS #####
# - v and pr clusters are running
####################

# TODO, get exact permissions you need

v0 write -f sys/replication/dr/primary/enable

SECONDARY_ENABLE_TOKEN=$(v0 write sys/replication/dr/primary/secondary-token id="dr-secondary" -format=json | jq -r '.wrap_info.token')

### Not Scripted ###
# - Sign in to dr
####################

dr0 write sys/replication/dr/secondary/enable token=$SECONDARY_ENABLE_TOKEN

v0 read sys/replication/dr/status -format=json | jq
dr0 read sys/replication/dr/status -format=json | jq

## Unseal key fail over route
dr0 operator generate-root -dr-token -init -format=json > generate-dr.json
NONCE=$(cat generate-dr.json | jq -r '.nonce')
OTP=$(cat generate-dr.json | jq -r '.otp')
echo $NONCE
echo $OTP
rm generate-dr.json


### Not Scripted ###
# - Grab your unseal key
# - example: UNSEAL_KEY=""
####################

# If you need to cancel
# dr0 operator generate-root -dr-token -cancel

ENCODED_DR_TOKEN=$(dr0 operator generate-root -format=json -dr-token -nonce=$NONCE  $UNSEAL_KEY | jq -r '.encoded_token')

DR_TOKEN=$(dr0 operator generate-root -dr-token \
    -decode=$ENCODED_DR_TOKEN \
    -otp=$OTP)
echo $DR_TOKEN

## Batch token fail over route
v0 policy write dr-secondary-promotion - <<EOF
path "sys/replication/dr/secondary/promote" {
  capabilities = [ "update" ]
}

# To update the primary to connect
path "sys/replication/dr/secondary/update-primary" {
    capabilities = [ "update" ]
}

# Only if using integrated storage (raft) as the storage backend
# To read the current autopilot status
path "sys/storage/raft/autopilot/state" {
    capabilities = [ "update" , "read" ]
}
path "sys/storage/raft/autopilot/configuration" {
    capabilities = [ "update" , "read" ]
}
EOF

v0 write auth/token/roles/failover-handler \
    allowed_policies=dr-secondary-promotion \
    orphan=true \
    renewable=false \
    token_type=batch

DR_OPERATION_TOKEN=$(v0 token create -role=failover-handler -ttl=8h -field=token)

# Promote secondary and demote secondary
dr0 write sys/replication/dr/secondary/promote dr_operation_token=$DR_OPERATION_TOKEN

v0 write -f sys/replication/dr/primary/disable

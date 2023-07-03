
# Set up based k1 v1/v2 configuration
vault secrets enable -path=kv1 kv
vault secrets enable -version=2 -path=kv2 kv

# Write data to each mount at path "max"
vault kv put kv1/max pass=1234 username=max
vault kv put kv2/max pass=1234 username=max

# Get data from each mount path
vault kv get kv1/max
vault kv get kv2/max

# Update one key in each path
vault kv put kv1/max pass=4321
vault kv patch kv2/max pass=4321

# View results
vault kv get kv1/max
vault kv get kv2/max

# Patch KV2
vault kv patch kv2/max pass=9999
vault kv get kv2/max

# Delete version and get result
vault kv delete -versions=3 kv2/max
vault kv get kv2/max

# Undelete version and get result
vault kv undelete -versions=3 kv2/max
vault kv get kv2/max

# Rollback to version 2 of secret and get result
vault kv rollback -version=2 kv2/max
vault kv get kv2/max

# Delete all versions of data
vault kv metadata delete kv2/max
vault kv get kv2/max
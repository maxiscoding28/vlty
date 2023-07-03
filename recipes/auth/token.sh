# Service
VAULT_SERVICE_TOKEN=$(vault token -field=token create -policy=default)
vault token lookup $VAULT_SERVICE_TOKEN

# Batch
VAULT_BATCH_TOKEN=$(vault token create -field=token -type=batch -policy=default -orphan=true)
vault token lookup $VAULT_BATCH_TOKEN

# Periodic
VAULT_PERIODIC_TOKEN=$(vault token create -period=24h -policy=default -field=token)
vault token lookup $VAULT_PERIODIC_TOKEN

# Orphan
VAULT_ORPHAN_TOKEN=$(vault token create -field=token -policy=default -orphan=true)
vault token lookup $VAULT_ORPHAN_TOKEN

# Revoke
VAULT_TOKEN=$(vault token create -field=token -policy=default -orphan=true)
vault token lookup $VAULT_TOKEN
vault token revoke $VAULT_TOKEN
vault token lookup $VAULT_TOKEN

# Renew
PERIODIC_TOKEN=$(vault token create -period=24s -policy=default -field=token)
vault token lookup $PERIODIC_TOKEN
vault token renew $PERIODIC_TOKEN
vault token lookup $PERIODIC_TOKEN
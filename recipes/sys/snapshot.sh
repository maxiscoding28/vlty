# Manual
vault operator raft snapshot save test.snap

vault operator raft snapshot restore test.snap.nogit

# Automated
vault write sys/storage/raft/snapshot-auto/config/test \
    interval=10s \
    retain=10 \
    storage_type=local \
    local_max_space=100000 \
    path_prefix=/vault/snapshots

vault delete sys/storage/raft/snapshot-auto/config/test
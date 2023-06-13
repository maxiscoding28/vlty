listener "tcp" {
    address = "0.0.0.0:8212"
    cluster_address = "0.0.0.0:8213"
    tls_disable = 1
}
  
storage "raft" {
    path = "/opt/vault/data"
    node_id = "pr0"
    retry_join = {
        leader_api_addr = "http://pr1:8214"
    }
    retry_join = {
        leader_api_addr = "http://pr2:8216"
    }
}

api_addr = "http://pr0:8212"
cluster_addr = "http://pr0:8213"
cluster_name = "pr-cluster"
ui = true
log_level = "info"
raw_storage_endpoint = true

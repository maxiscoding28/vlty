listener "tcp" {
    address = "0.0.0.0:8206"
    cluster_address = "0.0.0.0:8207"
    tls_disable = 1
}
  
storage "raft" {
    path = "/opt/vault/data"
    node_id = "dr0"
    retry_join = {
        leader_api_addr = "http://dr1:8208"
    }
    retry_join = {
        leader_api_addr = "http://dr2:8210"
    }
}

api_addr = "http://dr0:8206"
cluster_addr = "http://dr0:8207"
cluster_name = "dr-cluster"
ui = true
log_level = "info"
raw_storage_endpoint = true

listener "tcp" {
    address = "0.0.0.0:8210"
    cluster_address = "0.0.0.0:8211"
    tls_disable = 1
}
  
storage "raft" {
    path = "/opt/vault/data"
    node_id = "dr2"
    retry_join = {
        leader_api_addr = "http://dr0:8206"
    }
    retry_join = {
        leader_api_addr = "http://dr1:8208"
    }
}

api_addr = "http://dr2:8210"
cluster_addr = "http://dr2:8211"
cluster_name = "dr-cluster"
ui = true
log_level = "info"
raw_storage_endpoint = true

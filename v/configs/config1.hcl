listener "tcp" {
    address = "0.0.0.0:8202"
    cluster_address = "0.0.0.0:8203"
    tls_disable = 1
}
  
storage "raft" {
    path = "/opt/vault/data"
    node_id = "v1"
    retry_join = {
        leader_api_addr = "http://v0:8200"
    }
    retry_join = {
        leader_api_addr = "http://v2:8204"
    }
}

telemetry {
  disable_hostname = true
  prometheus_retention_time = "12h"
}

api_addr = "http://v1:8202"
cluster_addr = "http://v1:8203"
cluster_name = "v-cluster"
ui = true
log_level = "info"
raw_storage_endpoint = true
disable_performance_standby = false


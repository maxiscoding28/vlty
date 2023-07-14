listener "tcp" {
    address = "0.0.0.0:8204"
    cluster_address = "0.0.0.0:8205"
    tls_disable = 1
}

storage "raft" {
    path = "/opt/vault/data"
    node_id = "v2"
    retry_join = {
        leader_api_addr = "http://v0:8200"
    }
    retry_join = {
        leader_api_addr = "http://v1:8202"
    }
}

telemetry {
  disable_hostname = true
  prometheus_retention_time = "12h"
}

api_addr = "http://v2:8204"
cluster_addr = "http://v2:8205"
cluster_name = "v"
// ui = true
log_level = "info"
raw_storage_endpoint = true
disable_performance_standby = false


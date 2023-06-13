listener "tcp" {
    address = "0.0.0.0:8218"
    cluster_address = "0.0.0.0:8219"
    tls_disable = 1
  telemetry {
    unauthenticated_metrics_access = true
  }
}
  
storage "raft" {
    path = "/opt/vault/data"
    node_id = "aws0"
}

seal "awskms" {
  region = "us-west-2"
}

telemetry {
  disable_hostname = true
  prometheus_retention_time = "12h"
}

api_addr = "http://aws0:8218"
cluster_addr = "http://aws0:8219"
cluster_name = "aws-cluster"
ui = true
log_level = "info"
raw_storage_endpoint = true

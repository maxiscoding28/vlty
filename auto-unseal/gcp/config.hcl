listener "tcp" {
    address = "0.0.0.0:8222"
    cluster_address = "0.0.0.0:8223"
    tls_disable = 1
  telemetry {
    unauthenticated_metrics_access = true
  }
}
  
storage "raft" {
    path = "/opt/vault/data"
    node_id = "gcp0"
}

seal "gcpckms" {
  credentials = "/vault/config/gcp-sa-creds.json"
  region      = "global"
}

telemetry {
  disable_hostname = true
  prometheus_retention_time = "12h"
}

api_addr = "http://gcp0:8222"
cluster_addr = "http://gcp0:8223"
cluster_name = "gcp-cluster"
ui = true
log_level = "info"
raw_storage_endpoint = true

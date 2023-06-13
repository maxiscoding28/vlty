listener "tcp" {
    address = "0.0.0.0:8224"
    cluster_address = "0.0.0.0:8225"
    tls_disable = 1
  telemetry {
    unauthenticated_metrics_access = true
  }
}
  
storage "raft" {
    path = "/opt/vault/data"
    node_id = "azure0"
}

seal "azurekeyvault" {
  tenant_id      = "f5662df6-dc40-4331-bbd5-550bc91adef4"
  client_id      = "0c906087-d7dc-47e9-8b7b-956a0dcba0c8"
  client_secret  = "P5.8Q~I-BMW.KXrBN1WQUtgXNZXiQQmTIm4C-ae7"
  vault_name     = ""
  key_name       = ""
}



telemetry {
  disable_hostname = true
  prometheus_retention_time = "12h"
}

api_addr = "http://azure0:8224"
cluster_addr = "http://azure0:8225"
cluster_name = "gcp-cluster"
ui = true
log_level = "info"
raw_storage_endpoint = true

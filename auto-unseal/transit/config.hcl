listener "tcp" {
    address = "0.0.0.0:8220"
    cluster_address = "0.0.0.0:8220"
    tls_disable = 1
}
  
storage "raft" {
    path = "/opt/vault/data"
    node_id = "transit"
}

api_addr = "http://transit:8220"
cluster_addr = "http://transit:8221"
cluster_name = "transit"
ui = true
log_level = "info"
raw_storage_endpoint = true

seal "transit" {
  address = "http://v0:8200"
  disable_renewal = "false"
  key_name = "autounseal"
  mount_path = "transit/"
  tls_skip_verify = "true"
}

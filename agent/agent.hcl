auto_auth {
  method "approle" {
    config = {
      role_id_file_path   = "/vault/agent/role-id"
      secret_id_file_path = "/vault/agent/secret-id"
      remove_secret_id_file_after_reading = false
    }
  }
}

// template {
//   source      = "/vault/agent/template.ctmpl"
//   destination = "/vault/render.pem"
// }

template {
  source      = "/vault/agent/cert.ctmpl"
  destination = "/vault/cert.pem"
}
template {
  source      = "/vault/agent/key.ctmpl"
  destination = "/vault/key.pem"
}
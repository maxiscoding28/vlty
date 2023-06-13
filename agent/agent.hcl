listener "tcp" {
  address = "0.0.0.0:8210"
  tls_disable = true
}

api_proxy {
  // use_auto_auth_token = "true"
}

cache {
  use_auto_auth_token = "true"
}

auto_auth {
  method "approle" {
    config = {
      role_id_file_path   = "/vault/agent/role-id"
      secret_id_file_path = "/vault/agent/secret-id"
      remove_secret_id_file_after_reading = false
    }
  }

  sink "file" {
    config = {
      path = "/vault/token"
    }
  }
}

template_config {
  static_secret_render_interval = "5m"
}

template {
  source      = "/vault/agent/template.ctmpl"
  destination = "/vault/render.txt"
  error_on_missing_key = true
}
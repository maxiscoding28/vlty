provider "vault" {
  address = "http://127.0.0.1:8200"
  token   = "hvs.fDqUaBokzurxUMiN8emGsGCF"
}

# resource "vault_approle_auth_backend_role" "max2" {
#   backend        = "approle"
#   role_name      = "max2"
#   token_policies = ["default"]
# }

resource "vault_approle_auth_backend_role_secret_id" "id" {
  backend   = "approle"
  role_name = "max"
}
output "usweb_approle_secret_id" {
  value     = vault_approle_auth_backend_role_secret_id.id.secret_id
  sensitive = true
}
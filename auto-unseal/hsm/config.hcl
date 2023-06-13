
ui = true
log_level = "trace"
storage "file" {
    path = "/opt/vault/data"
}
listener "tcp" {
address = "0.0.0.0:8200"
tls_disable = 1
}
seal "pkcs11" {
lib            = "/usr/lib/softhsm/libsofthsm2.so"
slot           = "${VAULT_HSM_SLOT}"
pin            = "1234"
key_label      = "vault-hsm-key"
hmac_key_label = "vault-hsm-hmac-key"
generate_key   = "true"
}
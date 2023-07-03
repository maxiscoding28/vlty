# Enable PKI secrets engine
vault secrets enable pki

# Generate a root certificate
vault write -f pki/root/generate/exported common_name=max-root -format=json | jq -r '.data.certificate + "\n" + .data.private_key' > root.pem

## Inspect
openssl x509 -in root.pem -text -noout

# Create role for Root CA (for easy migration once expired) 
vault write pki/roles/v1-ca allow_any_name=true

# Configure CA and CRL urls
vault write pki/config/urls \
     issuing_certificates="$VAULT_ADDR/v1/pki/ca" \
     crl_distribution_points="$VAULT_ADDR/v1/pki/crl"

# Enable mount for intermediate PKI
vault secrets enable -path=pki_int pki

# Generate CSR and sign with Root CA
vault write -format=json pki_int/intermediate/generate/internal \
     common_name="max-int" \
     | jq -r '.data.csr' > int.csr

## Inspect
openssl req -in int.csr -text -noout

## Sign intermediate CSR
vault write -format=json pki/root/sign-intermediate \
    csr=@int.csr \
    | jq -r '.data.certificate' > int.cert.pem

## Inspect
openssl x509 -in int.cert.pem -text -noout

# Set signed for intermediate mount
vault write pki_int/intermediate/set-signed certificate=@int.cert.pem

# Create role
vault write pki_int/roles/max-role \
     allowed_domains="max.com" \
     allow_subdomains=true \
     ttl=12h

# Issue cert
vault write -format=json pki_int/issue/max-role common_name=test.max.com ttl=10s \
    | jq -r '.data.certificate + "\n" + .data.private_key' > leaf.pem

## Inspect
openssl x509 -in leaf.pem -text -noout

# Revoke Certificiate
vault write -f pki_int/revoke serial_number=

# Tidy Certificates
vault write -f pki_int/tidy tidy_cert_store=true tidy_revoked_certs=true safety_buffer=1s

# Cleanup
rm root.pem int.csr int.cert.pem leaf.pem
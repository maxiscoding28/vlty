vault auth enable cert

export WORKING_DIR=/Users/maxwinslow/sandbox-vault/vlty/recipes/auth/cert

cd $WORKING_DIR

openssl genpkey -algorithm RSA -out private-key.pem

# Verify valid private key
openssl rsa -check -in private-key.pem

cat << EOF > ca.cnf
[req]
default_bits = 2048
prompt = no
default_md = sha256
distinguished_name = dn

[dn]
C = US
ST = New York
L = New York City
O = Example Company
OU = IT Department
CN = example.com
EOF

openssl req -new -key private-key.pem -out ca-csr.pem -config ca.cnf

openssl x509 -req -days 365 -in ca-csr.pem -signkey private-key.pem -out ca-certificate.pem

openssl genpkey -algorithm RSA -out client-private-key.pem

cat << EOF > client.cnf
[req]
default_bits = 2048
prompt = no
default_md = sha256
distinguished_name = dn
req_extensions = req_ext

[dn]
C = US
ST = Colorado
L = Denver
O = Client
OU = HelpDesk
CN = denver.example.com

[req_ext]
keyUsage = digitalSignature, keyEncipherment
extendedKeyUsage = serverAuth, clientAuth
EOF

openssl req -new -key client-private-key.pem -out client-csr.pem -config client.cnf

openssl x509 -req -days 365 -in client-csr.pem -CA ca-certificate.pem -CAkey private-key.pem -out client-certificate.pem -CAcreateserial -copy-extensions

openssl verify -CAfile ca-certificate.pem client-certificate.pem


vault write auth/cert/certs/test \
    display_name=test \
    policies=admin \
    certificate=@ca-certificate.pem \
    ttl=3600

vault read auth/cert/certs/test

vault login -method=cert -client-cert=client-certificate.pem -client-key=client-private-key.pem name=test






curl \
    --request POST \
    --cacert root.pem \
    --cert client-certificate.pem \
    --key client-private-key.pem \
    --data '{"name": "test"}' \
    https://127.0.0.1:8200/v1/auth/cert/login

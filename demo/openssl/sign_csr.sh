#!/bin/bash

[[ $# -lt 2 ]] && {
    echo "Usage: $0 /path/to/csr cn"
    exit 1
}

CSR="$1"
CERTNAME="$2"

CA_BASE=/root/ca
ICA_BASE="${CA_BASE}/intermediate"
ICA_KEY="${ICA_BASE}/private/intermediate.key.tss"

CRT="${ICA_BASE}/certs/${CERTNAME}.cert.pem"


CA_CHAIN="${ICA_BASE}/certs/ca-chain.cert.pem"

cd "$CA_BASE" || {
    echo "Could not cd to $CA_BASE"
    exit 1
}
openssl ca \
    -config openssl_intermediate.cnf \
    -extensions server_cert \
    -engine tpm2tss \
    -keyform engine \
    -keyfile "$ICA_KEY" \
    -days 375 \
    -notext \
    -md sha256 \
    -in "$CSR" \
    -out "$CRT"
chmod 444 "$CRT"

cat <<EOF
Certificate created at ${CRT}.
You need this file as well as ${CA_CHAIN} in order to enable secure TLS foo in your application
EOF


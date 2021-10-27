CN=tpmdemo.example.com
BASE="$(realpath $(dirname $0))"
CA_BASE=/root/ca
ICA_BASE="${CA_BASE}/intermediate"

KEY="${ICA_BASE}/private/${CN}.key.pem"
CSR="${ICA_BASE}/csr/${CN}.csr"

openssl genrsa \
    -out "$KEY" 2048

openssl req \
    -config "${CA_BASE}/openssl_intermediate.cnf" \
    -key "$KEY" \
    -new \
    -sha256 \
    -out "$CSR"

bash -x "${BASE}/sign_csr.sh" "$CSR" "$CN"

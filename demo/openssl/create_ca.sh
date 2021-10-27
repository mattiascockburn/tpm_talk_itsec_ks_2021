#!/bin/bash
# mostly taken from https://jamielinux.com/docs/openssl-certificate-authority/
CA_BASE=/root/ca
CA_KEY="${CA_BASE}/private/ca.key.tss"
CA_CERT="${CA_BASE}/certs/ca.cert.pem"

ICA_BASE="${CA_BASE}/intermediate"
ICA_KEY="${ICA_BASE}/private/intermediate.key.tss"
ICA_CERT="${ICA_BASE}/certs/intermediate.cert.pem"
ICA_CSR="${ICA_BASE}/csr/intermediate.csr.pem"

CA_CHAIN="${ICA_BASE}/certs/ca-chain.cert.pem"

for d in "$CA_BASE" "$ICA_BASE"; do
    mkdir -pv "$d"/{certs,crl,newcerts,private}
    chmod 700 "${d}/private"
    touch "${d}/index.txt"
    echo 1000 > "${d}/serial"
done

cp -v openssl*.cnf "$CA_BASE"

# First, prepare the Root CA
cd "$CA_BASE"
tpm2tss-genkey --alg rsa --keysize 2048 "$CA_KEY"
chmod 400 "$CA_KEY"

openssl req \
    -config openssl.cnf \
    -new -x509 \
    -engine tpm2tss \
    -key "$CA_KEY" \
    -keyform engine \
    -new -x509 \
    -days 7300 \
    -sha256 \
    -extensions v3_ca \
    -out "$CA_CERT"

chmod 444 "$CA_CERT"

# And now the intermediate CA

cd "$ICA_BASE" || {
    echo Could not change to intermediate CA dir
    exit 1
}
echo 1000 > "${ICA_BASE}/crlnumber"
tpm2tss-genkey --alg rsa --keysize 2048 "$ICA_KEY"
chmod 400 "$ICA_KEY"

cd "$CA_BASE"
mkdir -pv "${ICA_BASE}/csr"

openssl req \
    -config openssl_intermediate.cnf \
    -new \
    -sha256 \
    -engine tpm2tss \
    -keyform engine \
    -key "$ICA_KEY" \
    -out "$ICA_CSR"

openssl ca \
    -config openssl.cnf \
    -extensions v3_intermediate_ca \
    -days 3650 \
    -notext \
    -md sha256 \
    -engine tpm2tss \
    -keyform engine \
    -in "$ICA_CSR" \
    -out "$ICA_CERT"

chmod 444 "$ICA_CERT"

openssl verify -CAfile "$CA_CERT" "$ICA_CERT"

cat "$ICA_CERT" "$CA_CERT" > "$CA_CHAIN"
chmod 444 "$CA_CHAIN"

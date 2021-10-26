#!/bin/bash
BASE=$(realpath $(dirname $0))
CA="${BASE}/../ca/snakeoil_ca.pem"
CAKEY="${BASE}/../ca/snakeoil_ca.key"
CSR="${BASE}/server.csr"
CRT="${BASE}/server.crt"
tpm2tss-genkey -a rsa "${BASE}/rsa.tss"
openssl req -new -engine tpm2tss -config "${BASE}/csr.conf" -key "${BASE}/rsa.tss"  -keyform engine -out "$CSR"
openssl x509 -req -days 360 -in "$CSR" -CA "$CA" -CAkey "$CAKEY" -CAcreateserial -out "$CRT"


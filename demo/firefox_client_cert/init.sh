#!/bin/bash

VARS=$(dirname $0)/vars_apache

[[ $# -eq 1 ]] || {
  echo "Usage: $0 /path/to/vars_file"
  exit 1
}
  VARS="$1"

if [ -f "$VARS" ]; then
  . "$VARS"
else
  echo "File $VARS does not seem to exist"
  exit 1
fi

PKCS11_TOOL='pkcs11-tool --module /usr/lib/pkcs11/libtpm2_pkcs11.so'
export OPENSSL_CONF="${BASE}/openssl.cnf"

tpm2_clear
tpm2_ptool init
tpm2_ptool addtoken --pid="$PID" --sopin="$SOPIN" --userpin="$USERPIN" --label="$LABEL"
tpm2_ptool addkey --algorithm="$CYPHER" --label="$LABEL" --userpin="$USERPIN"
TPM2ID=$($PKCS11_TOOL -O -l --pin "$USERPIN" 2>/dev/null | grep ID | uniq | awk '{ print $2; };')
cat <<EOF >/tmp/openssl.expect
spawn openssl req -new -extensions "$CSR_EXTENSIONS" -engine pkcs11 -keyform engine -key "slot_${PID}-id_${TPM2ID}" -out "$CSR" -subj "/CN=$CERT_CN"
expect "Enter PKCS#11 token PIN*" {
  send "${USERPIN}\r"
}
interact
EOF
expect -f /tmp/openssl.expect
tpm2_ptool listtokens --pid "$PID"

cat <<EOF
CSR was written to "$CSR"
Once you have your cert you may add it to the TPM with the following command:

tpm2_ptool addcert --label="$LABEL" --key-id="$TPM2ID" /path/to/cert

In order to let Apache use this Cert/Key you need to define config similar to this:

SSLCertificateFile    "pkcs11:id=%01;token=softhsm;type=cert"
SSLCertificateKeyFile "pkcs11:id=%01;token=softhsm;type=private?pin-value=111111"

Make sure to extend the systemd Unit so that the right TPM2 store is referenced, e.g.
cat /etc/systemd/system/myservice.d/tpm2store.conf
[Service]
Environment=TPM2_PKCS11_STORE=$TPM2_PKCS11_STORE
EOF

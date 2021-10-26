#!/bin/bash
. $(dirname $0)/vars
tpm2_clear
tpm2_ptool init
tpm2_ptool addtoken --pid="$PID" --sopin="$SOPIN" --userpin="$USERPIN" --label="$LABEL"
tpm2_ptool addkey --algorithm="$CYPHER" --label="$LABEL" --userpin="$USERPIN"
export TPM2ID=$($PKCS11_TOOL -O -l --pin "$USERPIN" 2>/dev/null | grep ID | uniq | awk '{ print $2; };')
cat <<EOF >/tmp/openssl.expect
spawn openssl req -new -engine pkcs11 -keyform engine -key "slot_${PID}-id_${TPM2ID}" -out "$CSR" -subj "/CN=$CERT_CN"
expect "Enter PKCS#11 token PIN*" {
  send "${USERPIN}\r"
}
interact
EOF
expect -f /tmp/openssl.expect
tpm2_ptool listtokens --pid "$PID"

openssl x509 -req -days 360 -in "$CSR" -CA "$CA" -CAkey "$CAKEY" -CAcreateserial -out "$CRT"

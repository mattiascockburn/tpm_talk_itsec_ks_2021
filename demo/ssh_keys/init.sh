#!/bin/bash
. $(dirname $0)/vars

tpm2_ptool init
tpm2_ptool addtoken --pid="$PID" --label="$LABEL" --sopin="$SOPIN" --userpin="$USERPIN"
tpm2_ptool addkey --algorithm="$CYPHER" --label="$LABEL" --userpin="$USERPIN"

ssh-keygen -D /usr/lib/pkcs11/libtpm2_pkcs11.so | tee ssh_pubkey

cat <<EOF
You may now transfer ssh_pubkey to the target machine.
User the following commandline to login:

ssh -I /usr/lib/pkcs11/libtpm2_pkcs11.so user@target
EOF

#!/bin/bash
# This part requires that you have a firefox profile named tpm-test,
# that has a security device configured that uses /usr/lib/pkcs11/libtpm2_pkcs11.so
. $(dirname $0)/vars
/usr/bin/firefox -p tpm-test


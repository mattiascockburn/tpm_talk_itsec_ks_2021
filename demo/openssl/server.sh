openssl s_server -cert server.crt -key server.key -keyform engine -engine tpm2tss -accept \*:8443

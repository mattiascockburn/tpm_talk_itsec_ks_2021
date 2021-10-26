## Demos 🧠⌚



## Toolset allgemein

```text
$ ls -1 /usr/bin/tpm2* | wc -l
103
```

Whoa 🤯


### Zufallsfahl generieren

`tpm2_getrandom --hex 16`



## openssl


### Engine Check

```text
$ openssl engine -t -c tpm2tss
(tpm2tss) TPM2-TSS engine for OpenSSL
 [RSA, RAND]
     [ available ]
```


### Zufallszahlen

```text
$ openssl rand -engine tpm2tss -hex 10
engine "tpm2tss" set.
acb6e5087d85393ad354
```


### RSA encrypt/decrypt

```text
$ echo Hello World > mydata
$ tpm2tss-genkey -a rsa -s 2048 mykey
$ openssl pkeyutl -engine tpm2tss -keyform engine \
    -inkey mykey -encrypt -in mydata -out mycipher
$ file mycipher
mycipher: data
$ openssl pkeyutl -engine tpm2tss -keyform engine \
    -inkey mykey -decrypt -in mycipher -out -
Hello World
```


### TLS Server Cert in Apache

Demo Time! 🙌



## PKCS#11


### SSH Auth via TPM

Demo Time! 🙌


### TLS Clientauth via PKCS#11 in Firefox🦊

Demo Time! 🙌



### systemd 248 - systemd-cryptenroll

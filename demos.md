## Demos 🧠⌚



## Toolset allgemein

```text
$ ls -1 /usr/bin/tpm2* | wc -l
103
```

Whoa 🤯


### Chip abfragen

```text
tpm2_getcap -l
tpm2_getcap properties-fixed
```


### EventLog lesen

```text
tpm2_eventlog \
  /sys/kernel/security/tpm0/binary_bios_measurements
```


### Zufallsfahl generieren

```text
tpm2_getrandom --hex 16
```


### TPM Reset

```text
# echo 5 > /sys/class/tpm/tpm0/ppi/request
```


### Hash erzeugen

```text
echo Hello World | tpm2_hash --hash-algorithm=sha256 --hex; echo
d2a84f4b8b650937ec8f73cd8be2c74add5a911ba64df27458ed8229da804a26
```



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


### OpenSSL CA

Demo Time! 🙌



## PKCS#11


### SSH Auth via TPM

Demo Time! 🙌


### TLS Clientauth via PKCS#11 in Firefox🦊

Demo Time? 🚧



### systemd-cryptenroll

* Ab systemd 248
* Automatischer Unlock von LUKS via TPM und mehr


### Enrollment

```text
# systemd-cryptenroll --tpm2-device=auto \
    --tpm2-pcrs=7 /dev/vda3
🔐 Please enter current passphrase for disk /dev/vda3: *****
New TPM2 token enrolled as key slot 1.
# cryptsetup luksDump /dev/vda3
[...]
Tokens:
  0: systemd-tpm2
	Keyslot:    1
[...]
```


### Config

```text
# cat /etc/crypttab
rootfs UUID=096ebd1d-foobar... - discard,tpm2-device=auto
```


### Dracut

```text
# cat <<EOF >/etc/dracut.conf.d/cryptenroll.conf
install_optional_items+=" /usr/lib64/libtss2* "
EOF
# dracut -f
# reboot
```

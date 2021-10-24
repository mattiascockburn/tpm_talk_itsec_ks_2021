## Trusted Platform Module Foobar 💾

Mattias Giese @ IT Sec Meetup Kassel Oktober 2021



## Warum?

* Windows 11 will es haben.
* Man kann lustige Sachen damit anstellen. 🙃



## TPM - Für was ist das gut? 🤔


### Bereitstellung kryptografischer Routinen

* Zufallszahlengenerator
* Generator für private Schlüssel (RSA, AES, ECC und andere Akronyme)
* Hash-Generator (SHA-1, SHA-256)


### Verifizierung des Systemzustandes

für "Measured Boot" und (Remote-)Attestion


### Sicheres speichern von Daten

* Speichern von beliebigen™ Inhalten
* Herausgabe von Infos nur wenn System verifiziert ist


### Ein wenig Geschichte

* Trusted Computing Platform Alliance -> Trusted Computing Group (ab 2003)
* Grundidee: HW Vendors können entscheiden, welche Software auf der Hardware läuft
* Kritik: Vendor-Lockin, DRM (Remote-Attestation Horror)
* In 2009: Veröffentlichung von ISO Standards
* Ab 2014: TPM 2.0, da real TPM
* Größte Errungenschaft: TPM Specs 1.2 und 2.0



## Wie sieht das Teil aus?


## Infineon SLB 9665

![Image of Infineon TPM chip](img/Infineon_SLB_9665.png)


## AddOn Chip für Mainboards

<p align="center">
  <img src="img/tpm_socket_mainboard.webp" height="250">
  <img src="img/asus_tpm_addon.webp" height="300">
</p>


## Let's Trust Chip für RPI

<p align="center">
  <img src="img/rpi4_tpm_1.jpg" height="350">
  <img src="img/rpi4_tpm_2.jpg" height="350">
</p>



### Andere Varianten

Neben dedizierten Chips gibt es noch andere Varianten bei der Implementierung des TPM.


### Integriert in andere Chips

Manche Intel Chipsets bringen ein TPM mit.


### Firmware TPM

Läuft in einem besonders gesicherten Bereich der CPU, Teil der UEFI Firmware


### Hypervisor TPM

z.B. in qemu/KVM, Hyper-V, VMWare


### Software TPM

z.B. swtpm: https://github.com/stefanberger/swtpm (auch qemu/KVM)



### Intro

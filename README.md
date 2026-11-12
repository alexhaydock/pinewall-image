# pinewall-image

This repository houses the image builder for my [Pinewall](https://github.com/alexhaydock/pinewall/) project.

It builds UKI images based that are ready-to use by injecting config at runtime using EFI variables, which are read by my [pinewall-init](https://github.com/alexhaydock/pinewall-init/) service.

### Generating SOPS-protected Secure Boot signing keys
```sh
# Generate Secure Boot DB & PCR keys
ukify genkey \
    --secureboot-private-key=keys/db-priv.pem \
    --secureboot-certificate=keys/db-cert.pem

# Generate Secure Boot PK key to provide the overall
# root of trust for our firmware. We don't really use
# this directly since we're not singing updates, but we
# need it to switch our firmware out of Setup Mode
openssl req -newkey rsa:4096 \
    -nodes -keyout keys/pk-priv.key \
    -new -x509 -sha256 -days 3650 \
    -subj "/CN=Pinewall Secure Boot PK/" \
    -out keys/pk-cert.pem

# Generate age keys (we will use this to encrypt the Secure Boot private keys)
age-keygen -o ~/age-pinewall.key

# Use SOPS to encrypt keys using the newly-generated age pubkey as the "target"
sops --encrypt --age age1wsrmfmhtsvfcdkq503ed32cmhluqgpw4g0hpe426dpyw43hk3y2sxgn890 --output keys/db-priv.pem.age keys/db-priv.pem
sops --encrypt --age age1wsrmfmhtsvfcdkq503ed32cmhluqgpw4g0hpe426dpyw43hk3y2sxgn890 --output keys/pk-priv.key.age keys/pk-priv.key

# Remove the unencrypted melange.rsa keyfile
rm -v keys/db-priv.pem keys/pk-priv.key

# Now, we can find the `AGE-SECRET-KEY-` string from the age keyfile
# and put it in the `SOPS_AGE_KEY` repo secret in GitHub
cat ~/age-pinewall.key
```

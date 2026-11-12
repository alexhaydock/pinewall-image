#!/usr/bin/env bash
set -euo pipefail

# Build initramfs and kernel into UKI
ukify build \
    --output "output/${BUILDNAME}_uki.efi" \
    --cmdline "rdinit=/sbin/init" \
    --linux "output/vmlinuz-lts" \
    --initrd "output/${BUILDNAME}_initramfs.zst" \
    --secureboot-private-key="keys/db-priv.pem" \
    --secureboot-certificate="keys/db-cert.pem" \
    --sign-kernel

# Validate UKI to make sure signing succeeded
sbverify \
    --cert "keys/db-cert.pem" \
    "output/${BUILDNAME}_uki.efi"

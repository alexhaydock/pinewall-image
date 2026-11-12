#!/usr/bin/env bash
set -euo pipefail

# Build the VARS store that uses our custom Secure Boot keys
virt-fw-vars \
  --output-json output/${BUILDNAME}_vars.json \
  --set-pk-cert "00000000-0000-0000-0000-000000000000" keys/pk-cert.pem \
  --add-db-cert "00000000-0000-0000-0000-000000000000" keys/db-cert.pem \
  --microsoft-db none \
  --microsoft-kek none \
  --secure-boot

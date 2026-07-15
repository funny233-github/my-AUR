#!/usr/bin/env bash
set -euo pipefail

cd "$(dirname "$0")"

echo "==> Cleaning linuxqq-self build artifacts..."

rm -rfv pkg/ src/
rm -fv *.deb *.zst *.zip

echo "==> Done."

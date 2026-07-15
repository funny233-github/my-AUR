#!/usr/bin/env bash
set -euo pipefail

cd "$(dirname "$0")"

echo "==> Cleaning ddnet-infclass-client build artifacts..."

rm -rfv pkg/ src/
rm -fv *.xz *.zst

echo "==> Done."

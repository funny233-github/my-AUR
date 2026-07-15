#!/usr/bin/env bash
set -euo pipefail

cd "$(dirname "$0")"

echo "==> Cleaning ddnet-binary build artifacts..."

rm -rfv pkg/ src/
rm -fv *.xz *.zst

echo "==> Done."

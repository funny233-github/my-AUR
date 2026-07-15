#!/usr/bin/env bash
set -euo pipefail

cd "$(dirname "$0")"

echo "==> Cleaning mindustry-self build artifacts..."

rm -rfv pkg/ src/
rm -fv *.pkg.tar.* *.tar.gz *.log

echo "==> Done."

#!/usr/bin/env bash
set -euo pipefail

cd "$(dirname "$0")"

echo "==> Cleaning terminal-browser-bin-self build artifacts..."

rm -rfv pkg/ src/
rm -fv *.tar.gz *.ico *.pkg.tar.* *.zst *.log LICENSE*

echo "==> Done."

#!/usr/bin/env bash
set -euo pipefail

cd "$(dirname "$0")"

echo "==> Cleaning wechat-bin-self build artifacts..."

rm -rfv pkg/ src/
rm -fv *.deb *.pkg.tar.* *.zst *.log

echo "==> Done."

#!/usr/bin/env bash
set -euo pipefail

cd "$(dirname "$0")"

echo "==> Cleaning cubiomes-viewer build artifacts..."

rm -rfv pkg/ src/ cubiomes-viewer/
rm -fv .PKGINFO
rm -fv *.pkg.tar.* *.pkg.tar.xz *.src.tar.gz *.log

echo "==> Done."

#!/usr/bin/env bash
set -euo pipefail

cd "$(dirname "$0")"
current=$(grep -oP '^pkgver=\K.*' PKGBUILD)

latest=$(curl -sSfL "https://ddnet.org/downloads/" 2>/dev/null | grep -oP 'DDNet-\K[0-9.]+(?=-linux_x86_64\.tar\.xz)' | head -1)

if [ "$current" = "$latest" ]; then
    echo "ddnet-binary-self: $current ✅"
    exit 0
else
    echo "ddnet-binary-self: $current → $latest ⬆️"
    exit 1
fi

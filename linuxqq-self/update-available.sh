#!/usr/bin/env bash
set -euo pipefail

cd "$(dirname "$0")"
current=$(grep -oP '^pkgver=\K.*' PKGBUILD)

latest=$(curl -sSf "https://aur.archlinux.org/rpc/v5/info/linuxqq" | jq -r '.results[0].Version' 2>/dev/null)
latest=${latest#*:}
latest=${latest%-*}

if [ "$current" = "$latest" ]; then
    echo "linuxqq-self: $current ✅"
    exit 0
else
    echo "linuxqq-self: $current → $latest ⬆️"
    exit 1
fi

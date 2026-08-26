#!/usr/bin/env bash
set -euo pipefail

cd "$(dirname "$0")"
current=$(grep -oP '^pkgver=\K.*' PKGBUILD)

latest=$(curl -sSf "https://api.github.com/repos/zenbu-labs/terminal-browser/releases/latest" \
         | jq -r '.tag_name' 2>/dev/null || true)
latest=${latest#v}

if [ -z "$latest" ] || [ "$current" = "$latest" ]; then
    echo "terminal-browser-bin-self: $current ✅"
    exit 0
else
    echo "terminal-browser-bin-self: $current → $latest ⬆️"
    exit 1
fi

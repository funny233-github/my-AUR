#!/usr/bin/env bash
set -euo pipefail

cd "$(dirname "$0")"
current=$(grep -oP '^pkgver="\K[^"]*' PKGBUILD)

latest=$(curl -sSf "https://api.github.com/repos/Anuken/Mindustry/releases/latest" | jq -r '.tag_name' 2>/dev/null)
latest=${latest#v}

if [ "$current" = "$latest" ]; then
    echo "mindustry-self: $current ✅"
    exit 0
else
    echo "mindustry-self: $current → $latest ⬆️"
    exit 1
fi

#!/usr/bin/env bash
set -euo pipefail

cd "$(dirname "$0")"
current_tag=$(grep -oP '^_tag=\K.*' PKGBUILD)

latest=$(curl -sSf "https://api.github.com/repos/BeyondDimension/SteamTools/releases/latest" | jq -r '.tag_name' 2>/dev/null)

if [ "$current_tag" = "$latest" ]; then
    echo "watt-toolkit-bin-self: $current_tag ✅"
    exit 0
else
    echo "watt-toolkit-bin-self: $current_tag → $latest ⬆️"
    exit 1
fi

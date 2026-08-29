#!/usr/bin/env bash
set -euo pipefail

cd "$(dirname "$0")"
current=$(grep -o 'pkgver=[^ #]*' PKGBUILD | cut -d= -f2)

latest=$(curl -sSf "https://api.github.com/repos/ggml-org/llama.cpp/releases?per_page=5" \
    | jq -r '[.[] | select(.prerelease == true)][0].tag_name // empty' \
    2>/dev/null)

if [ -z "$latest" ]; then
    echo "llama.cpp-cuda-self: $current (无法获取 pre-release，跳过)"
    exit 0
fi

if [ "$current" = "$latest" ]; then
    echo "llama.cpp-cuda-self: $current ✅"
    exit 0
else
    echo "llama.cpp-cuda-self: $current → $latest ⬆️"
    exit 1
fi

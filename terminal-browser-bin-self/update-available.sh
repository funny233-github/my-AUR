#!/usr/bin/env bash
set -euo pipefail

cd "$(dirname "$0")"
current=$(grep -oP '^pkgver=\K.*' PKGBUILD)

# Only accept plain vX.Y.Z tags (the browser line). The same repo also publishes
# unrelated series such as `pixel-v*` and `electron-v*`, which `releases/latest`
# happily returns and would be mistaken for a newer browser release.
latest=$(curl -sSf "https://api.github.com/repos/zenbu-labs/terminal-browser/releases?per_page=50" \
         | jq -r '[.[] | select(.prerelease == false) | .tag_name
                  | select(test("^v[0-9]+\\.[0-9]+\\.[0-9]+$"))][0] // empty' 2>/dev/null || true)
latest=${latest#v}

if [ -z "$latest" ] || [ "$current" = "$latest" ]; then
    echo "terminal-browser-bin-self: $current ✅"
    exit 0
else
    echo "terminal-browser-bin-self: $current → $latest ⬆️"
    exit 1
fi

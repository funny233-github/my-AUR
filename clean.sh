#!/usr/bin/env bash
set -euo pipefail

cd "$(dirname "$0")"

echo "============================================"
echo "  Cleaning all AUR package build artifacts"
echo "============================================"
echo ""

for dir in cubioms-viewer ddnet-binary ddnet-infclass-client; do
    if [ -f "$dir/clean.sh" ]; then
        echo ""
        (cd "$dir" && bash clean.sh)
    fi
done

echo ""
echo "============================================"
echo "  All packages cleaned."
echo "============================================"

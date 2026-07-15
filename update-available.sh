#!/usr/bin/env bash
set -euo pipefail

cd "$(dirname "$0")"

echo "========================================"
echo "  Checking for AUR package updates..."
echo "========================================"
echo ""

any_update=0
for dir in *-self/; do
    if [ -f "$dir/update-available.sh" ]; then
        (cd "$dir" && bash update-available.sh) || any_update=1
    fi
done

echo ""
if [ "$any_update" -eq 1 ]; then
    echo "⬆️  Some packages have updates available."
else
    echo "✅  All packages are up to date."
fi
echo "========================================"
exit "$any_update"

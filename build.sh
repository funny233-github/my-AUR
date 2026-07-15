#!/usr/bin/env bash
set -euo pipefail

cd "$(dirname "$0")"

if ! command -v parallel &>/dev/null; then
    echo "ERROR: GNU parallel is required."
    echo "Install it: sudo pacman -S parallel"
    exit 1
fi

# Config
TIMEOUT="${TIMEOUT:-600}"           # per-package timeout (seconds)
RETRIES="${RETRIES:-2}"             # max retries on failure/timeout
JOBS="${JOBS:-0}"                   # parallel jobs (0 = auto)
LOG_DIR="logs"
JOBLOG="$LOG_DIR/build.joblog"
mkdir -p "$LOG_DIR"

# Discover all packages with PKGBUILD
PACKAGES=()
for dir in *-self/; do
    [ -f "$dir/PKGBUILD" ] && PACKAGES+=("$dir")
done

if [ ${#PACKAGES[@]} -eq 0 ]; then
    echo "No *-self/ packages found."
    exit 0
fi

echo "============================================================"
echo "  Building ${#PACKAGES[@]} AUR packages"
echo "  Timeout: ${TIMEOUT}s per attempt, max ${RETRIES} retries"
echo "  Jobs:    $([ "$JOBS" -eq 0 ] && echo "auto" || echo "$JOBS")"
echo "  Log dir: $LOG_DIR/"
echo "============================================================"
echo ""

_JOBSCRIPT=$(mktemp)
cat > "$_JOBSCRIPT" << 'SCRIPT'
#!/usr/bin/env bash
set -euo pipefail
DIR="$1"
LOG="$2"
TIMEOUT="$3"
RETRIES="$4"
ROOT="$PWD"
cd "$DIR"
for ((i=1; i<=RETRIES+1; i++)); do
    if timeout "$TIMEOUT" makepkg -s --noconfirm --needed > "$ROOT/$LOG" 2>&1; then
        exit 0
    fi
    RET=$?
    if [ $RET -eq 124 ]; then
        echo "[TIMEOUT] $DIR (attempt $i/$RETRIES)" >> "$ROOT/$LOG"
    else
        echo "[FAIL] $DIR (attempt $i/$RETRIES - exit code $RET)" >> "$ROOT/$LOG"
    fi
    if [ "$i" -le "$RETRIES" ]; then
        sleep 2
    fi
done
exit 1
SCRIPT
chmod +x "$_JOBSCRIPT"

# Build parallel args
PARALLEL_ARGS=()
PARALLEL_ARGS+=(--timeout "$TIMEOUT")
PARALLEL_ARGS+=(--joblog "$JOBLOG")
PARALLEL_ARGS+=(--progress)
PARALLEL_ARGS+=(--line-buffer)
PARALLEL_ARGS+=(--tag)
[ "$JOBS" -gt 0 ] && PARALLEL_ARGS+=(-j "$JOBS")

# Run: pass dir, logfile, timeout, retries to job script
parallel "${PARALLEL_ARGS[@]}" \
    "$_JOBSCRIPT" {} "$LOG_DIR/{#}.log" "$TIMEOUT" "$RETRIES" \
    ::: "${PACKAGES[@]}"

rm -f "$_JOBSCRIPT"

echo ""
echo "============================================================"
echo "  Summary:"
awk 'NR>1 { printf "  %-40s %s (attempts: %d, time: %ds)\n", $9, ($7==0 ? "OK" : "FAIL"), $11, $4 }' "$JOBLOG" 2>/dev/null || true
echo ""
echo "  Full log:     $JOBLOG"
echo "  Per-package:  $LOG_DIR/*.log"
echo "============================================================"

# Exit with failure if any build failed
if awk 'NR>1 && $7 != 0' "$JOBLOG" | grep -q .; then
    exit 1
fi

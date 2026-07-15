# Agent Workflow: Updating linuxqq-self

This guide tells an AI coding agent how to update the `linuxqq-self` AUR package
when a new version of [Linux QQ](https://im.qq.com/linuxqq) is released.

---

## 1. Find the latest version

1. Use the AUR RPC API to check the community package version:
   ```bash
   curl -sSf "https://aur.archlinux.org/rpc/v5/info/linuxqq" | jq -r '.results[0].Version'
   ```
   Output looks like `5:3.2.31_51102-2` (epoch:version-rel).
   The version part (between `:` and `-`) is `pkgver`, e.g. `3.2.31_51102`.

2. Compare it against the current `pkgver` in `PKGBUILD`.

3. If the version has **not** changed, stop and tell the user:
   *"linuxqq is already at the latest version `<VERSION>`."* — do **not**
   make any changes.

4. If the version **has** changed, proceed.

> **Important**: If the API call fails, **stop** and tell the user. Do **not**
> guess or fabricate a version number.

---

## 2. Update PKGBUILD

1. Read `PKGBUILD` and locate the line `pkgver=...`.
2. Replace it with the new version string (e.g. `3.2.32_52000`).
3. Reset `pkgrel` to `1`.
4. Update `epoch` to match the community package's epoch (may stay the same).
5. **Get the download URLs** by cloning the community AUR PKGBUILD:
   ```bash
   git clone --depth=1 "https://aur.archlinux.org/linuxqq.git" /tmp/linuxqq-upstream
   ```
   Then read `/tmp/linuxqq-upstream/PKGBUILD` and extract:
   - `_md5_prefix` — copy the new value
   - `source_*` URLs — copy all `source_x86_64`, `source_aarch64`, `source_loong64`
   - `sha512sums` entries — copy all of them
   Update these values in your PKGBUILD. The `.deb` URL pattern changes with
   each release and the `_md5_prefix` cannot be derived from the version alone.
6. Clean up: `rm -rf /tmp/linuxqq-upstream`
7. The `_src_prefix` line must use the hardcoded `linuxqq_` prefix (NOT `linuxqq-self_`):
   ```bash
   _src_prefix="linuxqq_${pkgver/_/-}"
   ```
   The upstream deb filename uses `linuxqq_`, not `linuxqq-self_`.
8. `source=("linuxqq.sh")` must stay as-is (the launcher script filename).
9. `conflicts=('linuxqq-nt-bwrap')` must remain as-is (hardcoded, not using `$pkgname`).

---

## 3. Download and verify

```bash
makepkg -o
```

This will download the `.deb` files for all architectures.

---

## 4. Build

```bash
makepkg -si
```

---

## 5. Update .SRCINFO (if present)

```bash
makepkg --printsrcinfo > .SRCINFO
```

---

## Failure handling — ⚠️ STOP and ask the user

| Situation | Action |
|---|---|
| AUR API or git clone fails | Ask the user — the version/URLs may need to be fetched manually |
| `makepkg -o` fails (download error, 404) | **Stop.** The URL pattern may have changed. Tell the user. |
| `makepkg -si` fails | **Stop.** Show the user the full error output. |

**Cardinal rule**: Do **not** take corrective action on your own. Tell the user
and let them decide.

---

## Notes

- **Never commit/push** unless the user explicitly asks.
- The `_md5_prefix` in the download URL is unique per release and must be
  extracted from the community AUR PKGBUILD (via git clone) — it cannot be
  guessed.
- All `sha512sums` are copied directly from the community PKGBUILD.
- `url="https://im.qq.com/linuxqq"` — hardcoded, does NOT use `$pkgname`.

# Agent Workflow: Updating terminal-browser-bin-self

This guide tells an AI coding agent how to update the `terminal-browser-bin-self`
AUR package when a new version of [Terminal Browser](https://terminal-browser.sh)
is released.

---

## 1. Find the latest version

The `PKGBUILD` downloads pre-built binaries from
`https://terminal-browser.sh/install/dl/stable/v${pkgver}/...`.

Check the release feed for the latest tag and compare it against `pkgver` in
`PKGBUILD`. If they match, no update is needed.

---

## 2. Update PKGBUILD

1. Update `pkgver` to the new version number (without the leading `v`).
2. Reset `pkgrel` to `1`.
3. **Do not** touch `sha256sums_*` yet — the current values are pre-set and must
   be verified, not cleared.

---

## 3. Download and compute checksums

```bash
makepkg -o
sha256sum src/terminal-browser-linux-x64.tar.gz
sha256sum src/terminal-browser-linux-arm64.tar.gz
```

Update `sha256sums_x86_64` and (if on aarch64) `sha256sums_aarch64` in PKGBUILD.

---

## 4. Build

```bash
makepkg -s
```

The binary is installed to `/opt/terminal-browser/bin/terminal-browser` and
exposed via `/usr/bin/terminal-browser`.

---

## Failure handling

| Situation | Action |
|---|---|
| Release feed fails | Ask the user |
| `makepkg -o` fails | Stop. Asset naming or URL may have changed. |
| `makepkg -s` fails | Stop. Show the error. |

---

## Notes

- **Never commit/push** unless the user explicitly asks.
- Never guess a version number — always confirm from the upstream feed first.

# Agent Workflow: Updating terminal-browser-bin-self

This guide tells an AI coding agent how to update the `terminal-browser-bin-self`
AUR package when a new version of [Terminal Browser](https://terminal-browser.sh)
is released.

---

> ## ⚠️ Environment & network — read before starting
>
> **You run in an Alpine Linux VM, not Arch Linux.** `makepkg` is **not
> installed**, so:
> - Fetch sources with `curl`/`axel` and compute checksums by hand
>   (`sha256sum`/`sha512sum`). Do **not** use `makepkg -o` to download.
> - Edit `PKGBUILD` and `.SRCINFO` manually.
> - Ask the user to run `makepkg` / `makepkg -si` on their Arch machine to
>   verify. **Never run `makepkg` yourself.**
>
> **GitHub (and sometimes the AUR) may be unreachable** — the user is in
> mainland China. If a download, clone, or API call times out, 502s, or 403s:
> do **not** guess a version or fabricate a checksum. Report the exact error and
> ask the user to download the file / provide the checksum (hand the task back
> to them). `https://codeload.github.com/...` serves byte-identical content and
> may work as a fallback, but if it also fails, delegate to the user.


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

You cannot run `makepkg` in this Alpine VM. Download both tarballs directly and compute their checksums by hand:

```bash
curl -fL "https://terminal-browser.sh/install/dl/stable/v${pkgver}/terminal-browser-linux-x64.tar.gz" -o "terminal-browser-linux-x64.tar.gz"
curl -fL "https://terminal-browser.sh/install/dl/stable/v${pkgver}/terminal-browser-linux-arm64.tar.gz" -o "terminal-browser-linux-arm64.tar.gz"
sha256sum terminal-browser-linux-x64.tar.gz
sha256sum terminal-browser-linux-arm64.tar.gz
```

If `terminal-browser.sh` is unreachable, ask the user to download them and send the checksums.

Update `sha256sums_x86_64` and (if on aarch64) `sha256sums_aarch64` in PKGBUILD.

---

## 4. Build

Ask the user to run `makepkg -s` on their Arch machine to verify. **Never run
`makepkg` yourself.**

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

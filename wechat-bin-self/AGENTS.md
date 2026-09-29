# Agent Workflow: Updating wechat-bin-self

This guide tells an AI coding agent how to update the `wechat-bin-self` AUR
package when a new version of [WeChat](https://weixin.qq.com/) for Linux is
released.

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

The official download URL always points to the latest version (no version in
the URL). Use one of these methods to check the current version:

**Method A — AUR RPC API (recommended):**
```bash
curl -sSf "https://aur.archlinux.org/rpc/v5/info/wechat-bin" | jq -r '.results[0].Version'
```
Output looks like `4.1.1.8-1`. The version part is before the `-`.

**Method B — Download the .deb and extract:**
```bash
curl -sSfL -o /tmp/wechat-test.deb \
  "https://dldir1v6.qq.com/weixin/Universal/Linux/WeChatLinux_x86_64.deb"
ar p /tmp/wechat-test.deb control.tar.xz | tar -xJ ./control -O | grep '^Version:'
rm -f /tmp/wechat-test.deb ./control
```
The output will be `Version: 4.1.1.8`.

Compare the version against the current `pkgver` in `PKGBUILD`. If the version
has **not** changed, stop and tell the user:
*"WeChat is already at the latest version `<VERSION>`."* — do **not** make
any changes.

> **Important**: If both methods fail, **stop** and ask the user. Do **not**
> guess or fabricate a version number.

---

## 2. Update PKGBUILD

1. Update `pkgver` to the new version (e.g. `4.1.2.0`).
2. Reset `pkgrel` to `1`.
3. Update the `source_*` filenames to match the new version
   (e.g. `wechat-x86-<NEW_VER>.deb`, `wechat-arm-<NEW_VER>.deb`,
   `wechat-loong64-<NEW_VER>.deb`).
4. The download URLs themselves remain unchanged (they always point to the
   latest version).
5. `md5sums` stay `'SKIP'` (unversioned download).

---

## 3. Build and verify

Ask the user to run `makepkg -si` on their Arch machine to verify. **Never run
`makepkg` yourself.**

---

## 4. Update .SRCINFO (if present)

Regenerate it by hand, or ask the user to run
`makepkg --printsrcinfo > .SRCINFO` on their Arch machine.

---

## Failure handling — ⚠️ STOP and ask the user

| Situation | Action |
|---|---|
| Cannot confirm new version | Ask the user |
| `makepkg -o` / `makepkg -si` fails | **Stop.** Show the user the full error. |

---

## Notes

- **Never commit/push** unless the user explicitly asks.
- The `.deb` always downloads the latest version. Filenames in `PKGBUILD`
  should reflect the version for traceability, but the URLs are unversioned.
- The `pkgver()` function in `PKGBUILD` can extract the version from the
  downloaded `.deb` control file, but the agent should determine the version
  **before** modifying `PKGBUILD`.
- All checksums are `SKIP` since the download is unversioned.

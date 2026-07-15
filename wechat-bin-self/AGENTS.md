# Agent Workflow: Updating wechat-bin-self

This guide tells an AI coding agent how to update the `wechat-bin-self` AUR
package when a new version of [WeChat](https://weixin.qq.com/) for Linux is
released.

---

## 1. Find the latest version

1. Check the latest version from the upstream:
   - Visit the [WeChat Linux download page](https://weixin.qq.com/) and check
     the download link for Linux.
   - Or check the [AUR package page](https://aur.archlinux.org/packages/wechat-bin)
     for the current community version.
   - The download URL is: `https://dldir1v6.qq.com/weixin/Universal/Linux/WeChatLinux_x86_64.deb`
     (no version in the filename — the version is embedded in the `.deb` control file).
2. Compare it against the current `pkgver` in `PKGBUILD`.
3. If the version has **not** changed, stop and tell the user:
   *"WeChat is already at the latest version `<VERSION>`."*
4. If the version **has** changed, proceed.

> **Important**: If you cannot confirm the version, **stop** and ask the user.
> Do **not** guess.

---

## 2. Update PKGBUILD

1. Locate `pkgver=...` and replace with the new version.
2. Reset `pkgrel` to `1`.
3. Update the `source_*` URL filenames to match the new version
   (e.g. `wechat-x86-<NEW_VER>.deb`, `wechat-arm-<NEW_VER>.deb`).
4. The download URLs themselves remain the same (they always point to the
   latest version), but the local filenames should reflect the version.

---

## 3. Download the source

```bash
makepkg -o
```

---

## 4. Build and verify

```bash
makepkg -si
```

Since `md5sums` are set to `'SKIP'`, no hash update is needed.

---

## 5. Update .SRCINFO (if present)

```bash
makepkg --printsrcinfo > .SRCINFO
```

---

## Failure handling — ⚠️ STOP and ask the user

| Situation | Action |
|---|---|
| Cannot confirm new version | Ask the user |
| `makepkg -o` fails (download error) | **Stop.** The download URL may have changed. |
| `makepkg -si` fails | **Stop.** Show the user the full error. |

---

## Notes

- **Never commit/push** unless the user explicitly asks.
- The `.deb` file from the official site always downloads the latest version
  without a versioned URL. The version is extracted from the `.deb` control
  file during build.
- The `package()` function extracts from `data.tar.xz` inside the `.deb`.
- All checksums are `SKIP` since the download is unversioned.

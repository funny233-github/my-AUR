# Agent Workflow: Updating linuxqq-self

This guide tells an AI coding agent how to update the `linuxqq-self` AUR package
when a new version of [Linux QQ](https://im.qq.com/linuxqq) is released.

---

## 1. Find the latest version

1. Check the latest version from the upstream:
   - Visit <https://im.qq.com/linuxqq> or check the [AUR package page](https://aur.archlinux.org/packages/linuxqq) for the current community version.
   - Or check the Tencent QQ download page for Linux: <https://qqdownload.qq.com/qqfile/QQNT/Linux/>
2. Compare it against the current `pkgver` in `PKGBUILD`.
3. If the version has **not** changed, stop and tell the user: *"linuxqq is already at the latest version `<VERSION>`."*
4. If the version **has** changed (i.e., a newer release exists), proceed.

> **Important**: If you cannot confirm the version, **stop** and ask the user.
> Do **not** guess or fabricate a version number.

---

## 2. Update PKGBUILD

1. Read `PKGBUILD` and locate the line `pkgver=...`.
2. Replace it with the new version string (e.g. `3.2.32_52000`).
3. Reset `pkgrel` to `1`.
4. Update the `_md5_prefix` — this is extracted from the download URL on the
   Tencent QQ download page. You may need to inspect the page source or ask the
   user for the correct value.
5. Update the `source_*` URLs to match the new version and architecture.
6. Update the `sha512sums` entries — set them to `'SKIP'` initially, then
   update after downloading (see Step 4).

---

## 3. Download the source

```bash
makepkg -o
```

This will download the `.deb` files for all architectures.

---

## 4. Compute sha512sums

After the source is downloaded, compute the actual sha512sums:

```bash
sha512sum linuxqq_<NEW_VERSION>_amd64.deb
sha512sum linuxqq_<NEW_VERSION>_arm64.deb
sha512sum linuxqq_<NEW_VERSION>_loongarch64.deb
```

Update the corresponding entries in `sha512sums`, `sha512sums_x86_64`,
`sha512sums_aarch64`, `sha512sums_loong64`.

---

## 5. Build and verify

```bash
makepkg -si
```

If the build succeeds, the update is complete.

---

## 6. Update .SRCINFO (if present)

```bash
makepkg --printsrcinfo > .SRCINFO
```

---

## Failure handling — ⚠️ STOP and ask the user

| Situation | Action |
|---|---|
| Cannot confirm new version | Ask the user — check AUR community package or download page manually |
| `makepkg -o` fails (download error, 404) | **Stop.** The URL pattern may have changed. Tell the user. |
| `makepkg -si` fails | **Stop.** Show the user the full error output. |

**Cardinal rule**: Do **not** take corrective action on your own. Tell the user
and let them decide.

---

## Notes

- **Never commit/push** unless the user explicitly asks.
- The `_md5_prefix` in the download URL changes with each release and is
  specific to the build. It must be extracted from the official download page.
- `conflicts=('linuxqq-nt-bwrap')` must remain unchanged.

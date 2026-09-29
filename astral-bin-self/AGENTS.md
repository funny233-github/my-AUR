# Agent Workflow: Updating astral-bin-self

This guide tells an AI coding agent how to update the `astral-bin-self`
AUR package when a new version of [Astral](https://github.com/ldoubil/astral) is released.

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

```bash
curl -sSf "https://api.github.com/repos/ldoubil/astral/releases/latest" | jq -r '.tag_name'
```

Strip the `v` prefix for `pkgver`. Compare against `PKGBUILD`.

---

## 2. Update PKGBUILD

1. Update `pkgver`.
2. Reset `pkgrel` to `1`.
3. Set all `sha256sums_*` to `'SKIP'`.

---

## 3. Download and compute checksums

You cannot run `makepkg` in this Alpine VM. Download the assets directly and compute their checksums by hand (e.g.):

```bash
curl -fL "<release_asset_url>" -o "astral-linux-x64.tar.gz"
sha256sum astral-linux-x64.tar.gz   # and each of arm64 / icon.ico / .desktop
```

If `github.com` is unreachable, ask the user to download them and send the
checksums.

Update the corresponding entries in PKGBUILD.

---

## 4. Build

Ask the user to run `makepkg -s` on their Arch machine to verify. **Never run
`makepkg` yourself.**

---

## Failure handling

| Situation | Action |
|---|---|
| GitHub API fails | Ask the user |
| `makepkg -o` fails | Stop. Asset naming may have changed. |
| `makepkg -s` fails | Stop. Show the error. |

---

## Notes

- **Never commit/push** unless the user explicitly asks.
- The tar.gz is extracted to `/opt/astral/`; the binary is `/opt/astral/astral`.
- Desktop file requires `pkexec` (from `polkit`) for elevated privileges.
- License is PolyForm Noncommercial 1.0.0.

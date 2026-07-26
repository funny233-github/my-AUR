# Agent Workflow: Updating astral-bin-self

This guide tells an AI coding agent how to update the `astral-bin-self`
AUR package when a new version of [Astral](https://github.com/ldoubil/astral) is released.

---

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

```bash
makepkg -o
sha256sum src/astral-linux-x64.tar.gz
sha256sum src/astral-linux-arm64.tar.gz  # if on aarch64
sha256sum src/icon.ico
sha256sum src/astral.desktop
```

Update the corresponding entries in PKGBUILD.

---

## 4. Build

```bash
makepkg -s
```

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

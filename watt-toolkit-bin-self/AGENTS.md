# Agent Workflow: Updating watt-toolkit-bin-self

This guide tells an AI coding agent how to update the `watt-toolkit-bin-self`
AUR package when a new version of
[Watt Toolkit (Steam++)](https://github.com/BeyondDimension/SteamTools) is
released.

---

## 1. Find the latest version

1. Fetch the latest release from the GitHub API:
   ```bash
   curl -sSf "https://api.github.com/repos/BeyondDimension/SteamTools/releases/latest" | jq -r '.tag_name'
   ```
2. The output will look like `3.2.0`. Use this as `_tag` and `pkgver`
   (replace dots — e.g. `3.2.0` → `3.2.0`).
3. Compare it against the current `_tag` and `pkgver` in `PKGBUILD`.
4. If the version has **not** changed, stop and tell the user:
   *"Watt Toolkit is already at the latest version `<VERSION>`."*
5. If the version **has** changed, proceed.

> **Important**: If the API call fails, **stop** and tell the user.

---

## 2. Update PKGBUILD

1. Update `_tag` with the new tag (e.g. `3.2.0`).
2. Update `pkgver` — set to `${_tag//-/.}` (same pattern).
3. Reset `pkgrel` to `1`.
4. Update `source_x86_64` URL to match the new tag.
   Pattern: `https://github.com/BeyondDimension/SteamTools/releases/download/${_tag}/Steam++_v${_tag}_linux_x64.tgz`
5. Set `sha256sums_x86_64` to `'SKIP'` initially, then update after downloading.

---

## 3. Download the source

```bash
makepkg -o
```

---

## 4. Compute sha256sums

```bash
sha256sum Steam++_<NEW_VERSION>_x86_64.tar.gz
```

Update `sha256sums_x86_64` with the real hash. Also update the other
`sha256sums` entries if any local files changed.

---

## 5. Build and verify

```bash
makepkg -si
```

---

## 6. Update .SRCINFO (if present)

```bash
makepkg --printsrcinfo > .SRCINFO
```

---

## Failure handling — ⚠️ STOP and ask the user

| Situation | Action |
|---|---|
| GitHub API fails | Ask the user |
| `makepkg -o` fails (404, download error) | **Stop.** The URL pattern may have changed. |
| `makepkg -si` fails | **Stop.** Show the user the full error. |

---

## Notes

- **Never commit/push** unless the user explicitly asks.
- The `provides` and `conflicts` fields must remain as-is (`steam++`, `watt-toolkit`).
- The `set-cap.hook` uses `Target=watt-toolkit-bin-self` — keep it correct.
- `.gitignore` uses `*` (exclude all) with `!PKGBUILD !.SRCINFO !.gitignore` whitelist.

# Agent Workflow: Updating mindustry-self

This guide tells an AI coding agent how to update the `mindustry-self` AUR package
when a new version of [Mindustry](https://github.com/Anuken/Mindustry) is released.

This package builds from source and produces two subpackages:
- `mindustry-self` — the desktop game
- `mindustry-server-self` — the dedicated server

---

## 1. Find the latest version

1. Fetch the latest release from the GitHub API:
   ```bash
   curl -sSf "https://api.github.com/repos/Anuken/Mindustry/releases/latest" | jq -r '.tag_name'
   ```
2. The output will look like `v160`. Strip the leading `v` to get the version
   number (e.g. `160`).
3. Compare it against the current `pkgver` in `PKGBUILD`.
4. If the version has **not** changed, stop and tell the user:
   *"Mindustry is already at the latest version `<VERSION>`."* — do **not**
   make any changes.
5. If the version **has** changed (i.e., a newer release exists), proceed.

> **Important**: If the API call fails (network error, rate limit, etc.), **stop**
> and tell the user what happened. Do **not** guess or fabricate a version number.

---

## 2. Update PKGBUILD

1. Locate `pkgver=...` and replace with the new version.
2. Reset `pkgrel` to `1`.
3. Update `_build` to match the new version (e.g. `160`). This is used in
   source URLs and build scripts.
4. Update the `sha256sums` — set both entries to `'SKIP'` initially, then
   update after downloading (see Step 4).

**Only make these changes if the version is actually newer.**

---

## 3. Download the source

```bash
makepkg -o
```

This will download the Mindustry source tarball and the Arc library tarball
from GitHub.

---

## 4. Compute sha256sums

After the source is downloaded:

```bash
sha256sum mindustry-self-<NEW_VERSION>.tar.gz
sha256sum mindustry-self-arc-<NEW_VERSION>.tar.gz
```

Update the two `sha256sums` entries in `PKGBUILD` with the real hashes.

---

## 5. Build and verify

```bash
makepkg -si
```

This will build both `mindustry-self` and `mindustry-server-self`.

---

## 6. Update .SRCINFO (if present)

```bash
makepkg --printsrcinfo > .SRCINFO
```

---

## Failure handling — ⚠️ STOP and ask the user

| Situation | Action |
|---|---|
| `curl` / GitHub API fails | Ask the user |
| `makepkg -o` fails | **Stop.** The source URL pattern may have changed. |
| `makepkg -si` fails (Gradle error, missing deps) | **Stop.** Show the user the full error. |

---

## Notes

- **Never commit/push** unless the user explicitly asks.
- The package builds from source via Gradle — `java-environment=17` is required.
- Two subpackages are produced: `mindustry-self` and `mindustry-server-self`.

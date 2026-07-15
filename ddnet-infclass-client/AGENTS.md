# Agent Guide: Updating ddnet-infclass-client

This guide explains how to update this AUR package. Follow the steps **in order** and stop for user input when specified.

---

## Step 1 — Get the latest GitHub release version

Fetch the latest release tag from the upstream repository:

```bash
# Get the latest tag from GitHub
curl -sSf "https://api.github.com/repos/infclass/infclass-client/releases/latest" | jq -r '.tag_name'
```

The output should look like `v0.1.8`. Strip the leading `v` to get the version number (e.g. `0.1.8`).

If the API returns an error (rate-limited, network issue, etc.), **stop and ask the user** how to proceed.

---

## Step 2 — Update PKGBUILD

Update the following fields in `PKGBUILD`:

- `pkgver` — set to the new version (e.g. `0.1.9`)
- `pkgrel` — reset to `1`
- `source` — update the URL to point to the new release. The URL pattern is:

  ```
  https://github.com/infclass/infclass-client/releases/download/v{VERSION}/Infclass-{VERSION}-linux_x86_64_ubuntu_20.04.tar.xz
  ```

- `sha256sums` — set the tarball entry to `'SKIP'` for now (it will be updated in Step 4)

**Only make these changes in PKGBUILD if the version is actually newer than the current one.** If it's the same, stop and inform the user.

---

## Step 3 — Download the source tarball

Use `makepkg` to download only:

```bash
makepkg -o
```

This will fetch the source and verify the checksum (currently `SKIP`, so it will pass).

---

## Step 4 — Compute the correct sha256sum

After the source is downloaded, compute the actual sha256sum:

```bash
sha256sum "Infclass-${pkgver}-linux_x86_64_ubuntu_20.04.tar.xz"
# or if it's in src/:
sha256sum "src/Infclass-${pkgver}-linux_x86_64_ubuntu_20.04.tar.xz"
```

Then update `sha256sums` in `PKGBUILD` with the real hash.

---

## Step 5 — Build and verify

```bash
# Build the package
makepkg -si

# Check the package info is correct
pacman -Qip *.pkg.tar.zst
```

If the build succeeds, the update is complete. Proceed to Step 6.

---

## Step 6 — Update .SRCINFO (if present)

If a `.SRCINFO` file exists in the repository, regenerate it:

```bash
makepkg --printsrcinfo > .SRCINFO
```

---

## Failure handling — ⚠️ STOP and ask the user

| Situation | Action |
|---|---|
| `curl` / GitHub API fails (network error, rate limit) | Ask the user — the version may need to be fetched manually |
| `makepkg -o` fails because the URL returns **404** (file doesn't exist) | **Stop immediately.** Tell the user: the tarball for this version does not exist at the expected URL. The upstream may have changed the release asset name or the build system. Ask the user to decide what to do (e.g., check the release page manually, skip this version, etc.) |
| `makepkg -o` fails because of a **checksum mismatch** (and you haven't set SKIP) | This is expected — just update the sha256sum |
| `makepkg -o` fails with a **timeout** (connection timeout, slow download) | Ask the user whether to retry, increase timeout, or skip |
| `makepkg -si` fails (build error, dependency issue) | Ask the user — the upstream source may have changed its build structure |

**Rule of thumb:** If the failure is unexpected and unclear, don't guess. Tell the user what happened with the relevant output and ask them to decide.

---

## Notes

- **Never commit/push changes** unless the user explicitly asks you to.
- The tarball extracts to `Infclass-${pkgver}-linux_x86_64/`. If the upstream changes the extraction directory structure, the `package()` function in PKGBUILD may need updates too — stop and ask.

# Agent Workflow: Updating ddnet-self

This file instructs an AI coding agent on how to update the `ddnet-self` AUR
package when a new version of DDNet is released.

---

## 1. Find the latest version

1. Open <https://ddnet.org/downloads/> in a browser/web tool.
2. Locate the latest **Linux x86_64** download link.
3. Determine the version string from the filename. The URL pattern is:
   `https://ddnet.org/downloads/DDNet-<VERSION>-linux_x86_64.tar.xz`
4. Compare it against the current `pkgver` in `PKGBUILD`.
5. If the version has **not** changed, stop and tell the user: *"DDNet is already
   at the latest version `<VERSION>`."* — do **not** make any changes.
6. If the version **has** changed (i.e., a newer version exists than what is in
   `PKGBUILD`), proceed to the next step.

> **Important**: If you cannot find the version or the download URL for
> Linux x86_64, stop and tell the user what you found, then ask how to proceed.
> Do **not** guess or fabricate a version number.

---

## 2. Update pkgver in PKGBUILD

1. Read `PKGBUILD` and locate the line `pkgver=...`.
2. Replace it with the new version string.
3. **Do not** change `pkgrel` — that is for the user to decide. If the user
   later asks to bump `pkgrel`, do it on their explicit instruction.

---

## 3. Download the source tarball with axel

1. Construct the source URL:
   `https://ddnet.org/downloads/DDNet-<NEW_PKGVER>-linux_x86_64.tar.xz`
2. Change directory to the project root (where `PKGBUILD` lives).
3. Run `axel` to download the tarball:
   ```bash
   axel -n 4 -o "DDNet-<NEW_PKGVER>-linux_x86_64.tar.xz" \
     "https://ddnet.org/downloads/DDNet-<NEW_PKGVER>-linux_x86_64.tar.xz"
   ```
   - `-n 4` uses 4 connections for faster downloads.
   - The output filename follows the same pattern as the source.
4. If the download fails (HTTP error, network issue, etc.), **stop** and tell
   the user the exact error. Ask what they want to do. Do **not** proceed.

> **Note**: `.gitignore` already ignores `*.xz` files, so the downloaded
> tarball won't be accidentally committed.

---

## 4. Compute the sha256sums

1. Run:
   ```bash
   sha256sum "DDNet-<NEW_PKGVER>-linux_x86_64.tar.xz"
   ```
2. Extract just the hex hash (first column of output).
3. In `PKGBUILD`, replace the **first** entry in `sha256sums=('...' 'SKIP')`
   with the new hash. The `'SKIP'` for `DDNet.desktop` must remain untouched.
4. Make sure the format stays exactly: `('newhash' 'SKIP')`

---

## 5. Verify with makepkg

1. Run:
   ```bash
   makepkg -f
   ```
   - `-f` forces rebuild even if the tarball already exists.
2. If `makepkg` **succeeds** (exit code 0):
   - Clean up the built package file:
     ```bash
     rm -f "ddnet-self-<NEW_PKGVER>-1-x86_64.pkg.tar.zst"
     ```
   - Commit the changes:
     ```bash
     git add PKGBUILD
     git commit -m "update to <NEW_PKGVER>"
     ```
   - Tell the user: *"Updated ddnet-self to <NEW_PKGVER> and committed."*
3. If `makepkg` **fails**:
   - **Stop immediately**. Do **not** commit anything.
   - Show the user the full error output from `makepkg`.
   - Tell the user exactly what went wrong.
   - Ask the user: *"The build failed. What would you like to do? (e.g., fix
     the PKGBUILD, try a different approach, investigate further)"*
   - Wait for the user's instructions before proceeding.

---

## Rules for the agent

1. **Never commit on failure.** If `makepkg` returns non-zero, you must not
   stage or commit any file.
2. **Never guess a version number.** If you cannot confirm the version from
   ddnet.org, ask the user.
3. **Never change `pkgrel`** unless the user explicitly asks you to.
4. **Always show the user what version you found** and what the current one is.
5. **If anything unexpected happens** (e.g., the download URL pattern changed,
   the filename format changed), stop and report to the user.

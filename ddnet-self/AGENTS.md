# Agent Workflow: Updating ddnet-self

This file instructs an AI coding agent on how to update the `ddnet-self` AUR
package when a new version of DDNet is released.

---

> ## ⚠️ Environment & network — read before starting
>
> **You run in an Alpine Linux VM, not Arch Linux.** `makepkg` is **not
> installed**, so:
> - Fetch the tarball with `curl`/`axel` and compute `sha256sum` by hand — do
>   **not** use `makepkg -o` to download.
> - Edit `PKGBUILD` manually.
> - Ask the user to run `makepkg -f` on their Arch machine to verify; **never
>   run `makepkg` yourself.**
>
> **ddnet.org may be unreachable** — the user is in mainland China. If a
> download times out, 502s, or 403s, do **not** guess a version or fabricate a
> checksum. Report the exact error and ask the user to download the file /
> provide the checksum (hand the task back to them).

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

## 5. Verify (user runs makepkg)

You cannot run `makepkg` in this Alpine VM. Instead:

1. Confirm the `PKGBUILD` is correct: new `pkgver`, updated `sha256sums`
   (first entry), with `'SKIP'` for `DDNet.desktop` / the png untouched.
2. Ask the user to run `makepkg -f` on their Arch machine.
3. If it **succeeds**, have the user remove the built
   `ddnet-self-<NEW_PKGVER>-1-x86_64.pkg.tar.zst`, then commit (only after the
   user confirms the build succeeded):
   ```bash
   git add PKGBUILD
   git commit -m "update to <NEW_PKGVER>"
   ```
4. If it **fails**, stop, show the user the full error, and ask how to proceed.
   Do **not** commit anything on failure.

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

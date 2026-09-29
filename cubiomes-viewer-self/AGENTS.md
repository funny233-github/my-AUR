# Agent Workflow: Updating cubiomes-viewer

This guide tells an AI coding agent how to update the `cubiomes-viewer` AUR
package when a new version of [cubiomes-viewer](https://github.com/Cubitect/cubiomes-viewer) is released.

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

1. Fetch the latest release from the GitHub API:
   ```bash
   curl -sSf "https://api.github.com/repos/Cubitect/cubiomes-viewer/releases/latest" | jq -r '.tag_name'
   ```
2. The output will look like `v4.1.2`. Strip the leading `v` to get the version
   number (e.g. `4.1.2`).
3. Compare it against the current `pkgver` in `PKGBUILD`.
4. If the version has **not** changed, stop and tell the user:
   *"cubiomes-viewer is already at the latest version `<VERSION>`."* — do **not**
   make any changes.
5. If the version **has** changed (i.e., a newer release exists), proceed.

> **Important**: If the API call fails (network error, rate limit, etc.), **stop**
> and tell the user what happened. Ask how they want to proceed. Do **not**
> guess or fabricate a version number.

---

## 2. Update PKGBUILD

1. Read `PKGBUILD` and locate the line `pkgver=...`.
2. Replace it with the new version string (e.g. `4.2.0`).
3. Reset `pkgrel` to `1`.
4. The `source` entry is already a git URL with a tag variable —
   **do not change** the source URL pattern. It will pick up the new version
   automatically via the `$pkgver` variable.

**Only make these changes if the version is actually newer.** If it's the same,
stop and inform the user.

---

## 3. Download the source

You cannot run `makepkg` in this Alpine VM. Clone the tag directly (this also
covers submodules via `prepare()`):

```bash
git clone --depth 1 --branch v${pkgver} https://github.com/Cubitect/cubiomes-viewer.git
```

If `github.com` is unreachable (see the network note), use the
`https://codeload.github.com/...` fallback; if that also fails, ask the user to
clone it and send the tarball.

Since the source is a git checkout, `sha256sums` stays `'SKIP'`. No hash update
is needed.

---

## 4. Build and verify

Ask the user to run `makepkg -si` on their Arch machine to verify. **Never run
`makepkg` yourself.**

If the build succeeds, the update is complete. Proceed to Step 5.

---

## 5. Update .SRCINFO (if present)

If a `.SRCINFO` file exists in the repository, regenerate it by hand, or ask the
user to run `makepkg --printsrcinfo > .SRCINFO` on their Arch machine.

---

## Failure handling — ⚠️ STOP and ask the user

| Situation | Action |
|---|---|
| `curl` / GitHub API fails (network error, rate limit) | Ask the user — the version may need to be fetched manually |
| `makepkg -o` fails with a **timeout** | Ask the user whether to retry, increase timeout, or skip |
| `makepkg -o` fails for **any other reason** (git clone failure, submodule issue, tag not found) | **Stop immediately.** Tell the user the exact error and output. Ask them to decide what to do. Do **not** proceed, fix things, or make assumptions on your own |
| `makepkg -si` fails (build error, missing dependency, qmake issue) | **Stop immediately.** Show the user the full error output. Ask them how to proceed |

**Cardinal rule**: If the failure is anything **other than a timeout**, do
**not** take any corrective action on your own. Tell the user and let them
decide.

---

## Notes

- **Never commit/push changes** unless the user explicitly asks you to.
- The source is fetched via `git+https://github.com/Cubitect/cubiomes-viewer.git#tag=$pkgver` — the tag must exist on GitHub. If a release is published but the corresponding git tag is missing, that is a problem you cannot solve — ask the user.
- The `prepare()` function runs `git submodule update --init --recursive`. If the upstream changes their submodule structure, the build may break — stop and report.

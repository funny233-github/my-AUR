# Agent Workflow: Updating llama.cpp-cuda

This guide tells an AI coding agent how to update the `llama.cpp-cuda` AUR package.

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

1. Fetch the latest **pre-release** tag from GitHub:
   ```bash
   curl -sSf "https://api.github.com/repos/ggml-org/llama.cpp/releases?per_page=5" \
       | jq -r '[.[] | select(.prerelease == true)][0].tag_name // empty' 2>/dev/null
   ```
   The output will look like `b10680` (prefixed with `b`). Use this as `pkgver`.
3. Compare it against the current `pkgver` in `PKGBUILD`.
4. If the version has **not** changed, stop and tell the user:
   *"llama.cpp-cuda is already at the latest version `<VERSION>`."*
5. If the version **has** changed, proceed.

> **Important**: If the API call fails, **stop** and tell the user.

---

## 2. Update PKGBUILD

1. Update `pkgver` with the new tag (e.g. `b10680`).
2. Reset `pkgrel` to `1`.
3. Update `source[0]` URL:
   ```
   ${pkgname}-${pkgver}.tar.gz::https://github.com/ggml-org/llama.cpp/archive/refs/tags/${pkgver}.tar.gz
   ```
4. Set `sha256sums` to `'SKIP'` initially, then update after downloading.

---

## 3. Download the source

You cannot run `makepkg` in this Alpine VM. Download the tarball directly:

```bash
curl -fL "https://github.com/ggml-org/llama.cpp/archive/refs/tags/${pkgver}.tar.gz" \
  -o "${pkgname}-${pkgver}.tar.gz"
```

If `github.com` is unreachable (see the network note), use the
`https://codeload.github.com/...` fallback; if that also fails, ask the user to
download it and send the checksum.

---

## 4. Compute sha256sums

```bash
sha256sum llama.cpp-cuda-b<NEW_VERSION>.tar.gz llama.cpp.conf llama.cpp.service
```

Update `sha256sums` array with the real hashes. Also update `.SRCINFO`.

---

## 5. Build and verify

Ask the user to run `makepkg -si` on their Arch machine to verify. **Never run
`makepkg` yourself.**

---

## 6. Update .nvchecker.toml (if needed)

The upstream repo is `ggml-org/llama.cpp`, but the nvchecker source was originally
`ggerganov/llama.cpp`. The current `.nvchecker.toml` already points to
`ggml-org/llama.cpp` — verify it matches the actual upstream.

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
- The `provides` and `conflicts` fields must remain as-is (`llama.cpp`, `libggml`, `ggml`).
- This is a build-from-source package (not binary), so `sha256sums` validation is critical.
- Architecture support: x86_64, armv7h, aarch64.

# Agent Guide: Updating AUR Packages

This repository contains multiple AUR packages. Each subdirectory has its own
`AGENTS.md` file with detailed instructions for updating that specific package.

## Environment & network — read before starting

**You run in an Alpine Linux VM, not Arch Linux.** `makepkg` is **not
installed**, and a real build needs Arch-specific tooling, so:

- Fetch sources with `curl`/`axel` and compute checksums by hand
  (`sha256sum`/`sha512sum`). Do **not** rely on `makepkg -o` to download.
- Edit `PKGBUILD` and `.SRCINFO` manually (regenerate `.SRCINFO` by hand, or ask
  the user to run `makepkg --printsrcinfo` on their Arch machine).
- Ask the user to run `makepkg` / `makepkg -si` on their Arch machine to verify
  the build. **Never run `makepkg` yourself.**

**GitHub (and sometimes the AUR) may be unreachable** — the user is in mainland
China. If a download, clone, or API call times out, returns 502/403, or otherwise
fails: do **not** guess a version or fabricate a checksum. Report the exact error
and ask the user to download the file / provide the checksum (hand the task back
to them). `https://codeload.github.com/...` serves byte-identical content and may
work as a fallback, but if it also fails, delegate to the user.

## Workflow

When asked to update an AUR package:

1. **Identify the package** — determine which subdirectory to update.
2. **Read its AGENTS.md** — each subfolder contains a step-by-step guide for
   that package's update process.
3. **Follow the guide** — execute the steps exactly as described. Do not skip
   steps, guess version numbers, or make assumptions.
4. **On failure** — stop and report to the user. Do not take corrective action
   unless the guide explicitly allows it.

## Packages

| Directory | Package | AGENTS.md |
|---|---|---|
| `astral-bin-self/` | astral-bin-self | [astral-bin-self/AGENTS.md](astral-bin-self/AGENTS.md) |
| `cubiomes-viewer-self/` | cubiomes-viewer-self | [cubiomes-viewer-self/AGENTS.md](cubiomes-viewer-self/AGENTS.md) |
| `ddnet-self/` | ddnet-self | [ddnet-self/AGENTS.md](ddnet-self/AGENTS.md) |
| `linuxqq-self/` | linuxqq-self | [linuxqq-self/AGENTS.md](linuxqq-self/AGENTS.md) |
| `mindustry-self/` | mindustry-self | [mindustry-self/AGENTS.md](mindustry-self/AGENTS.md) |
| `watt-toolkit-bin-self/` | watt-toolkit-bin-self | [watt-toolkit-bin-self/AGENTS.md](watt-toolkit-bin-self/AGENTS.md) |
| `wechat-bin-self/` | wechat-bin-self | [wechat-bin-self/AGENTS.md](wechat-bin-self/AGENTS.md) |

## Important Notes

- **Never commit/push** unless the user explicitly asks.
- **Never guess** a version number — always fetch from the upstream source.
- If a package's `AGENTS.md` does not exist or is missing, ask the user for
  guidance before proceeding.
- **When creating or modifying a PKGBUILD**, you must manually expand and
  verify every variable reference in your head (口算). Common pitfalls:
  - `${pkgname%-self}` strips `-self` suffix → leaves `xxx-bin` or `xxx`
  - Local source filenames (`.desktop`, `.sh`, `.png`) must match the
    expanded variable exactly — check that the file on disk has the same name
  - SHA256/sha512 arrays must have the same count as their corresponding
    `source_*` arrays
  - Architecture-mapping variables like `${CARCH}` inside `package()` are
    not expanded at parse time — the logic must work for all declared arches
  - If you are unsure about any expansion, write it out explicitly rather
    than relying on shell parameter substitution that could be wrong

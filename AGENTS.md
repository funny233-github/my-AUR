# Agent Guide: Updating AUR Packages

This repository contains multiple AUR packages. Each subdirectory has its own
`AGENTS.md` file with detailed instructions for updating that specific package.

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
| `cubioms-viewer/` | cubiomes-viewer | [cubioms-viewer/AGENTS.md](cubioms-viewer/AGENTS.md) |
| `ddnet-binary/` | ddnet-binary | [ddnet-binary/AGENTS.md](ddnet-binary/AGENTS.md) |
| `ddnet-infclass-client/` | ddnet-infclass-client | [ddnet-infclass-client/AGENTS.md](ddnet-infclass-client/AGENTS.md) |

## Important Notes

- **Never commit/push** unless the user explicitly asks.
- **Never guess** a version number — always fetch from the upstream source.
- If a package's `AGENTS.md` does not exist or is missing, ask the user for
  guidance before proceeding.

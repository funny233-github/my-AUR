# AUR Packages

This repository contains user-maintained [AUR](https://wiki.archlinux.org/title/Arch_User_Repository)
(Arch User Repository) packages, built and managed locally.

## Packages

| Package | Description | Source |
|---|---|---|
| `cubiomes-viewer` | Efficient graphical seed finder and map viewer for Minecraft | [GitHub](https://github.com/Cubitect/cubiomes-viewer) |
| `ddnet-binary` | DDNet game from official website | [ddnet.org](https://ddnet.org) |
| `ddnet-infclass-client` | DDNet infclass client | [GitHub](https://github.com/infclass/infclass-client) |

## Usage

Build and install a package:

```bash
cd <package-name>
makepkg -si
```

Clean build artifacts for a package:

```bash
./clean.sh                    # clean all packages
./<package-name>/clean.sh     # clean a single package
```

## Updating

See `AGENTS.md` for instructions on how to update each package.

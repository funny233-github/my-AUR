# AUR Packages

This repository contains user-maintained [AUR](https://wiki.archlinux.org/title/Arch_User_Repository)
(Arch User Repository) packages, built and managed locally.

## Packages

| Package | Description | Source |
|---|---|---|
| `cubiomes-viewer-self` | Efficient graphical seed finder and map viewer for Minecraft | [GitHub](https://github.com/Cubitect/cubiomes-viewer) |
| `ddnet-binary-self` | DDNet game from official website | [ddnet.org](https://ddnet.org) |
| `ddnet-infclass-client-self` | DDNet infclass client | [GitHub](https://github.com/infclass/infclass-client) |
| `linuxqq-self` | New Linux QQ based on Electron | [im.qq.com](https://im.qq.com/linuxqq) |
| `mindustry-self` | A sandbox tower defense game (build from source) | [GitHub](https://github.com/Anuken/Mindustry) |
| `watt-toolkit-bin-self` | 开源跨平台的多功能Steam工具箱 | [steampp.net](https://steampp.net/) |
| `wechat-bin-self` | 微信 for Linux | [weixin.qq.com](https://weixin.qq.com/) |

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

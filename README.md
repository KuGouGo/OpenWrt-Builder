# OpenWrt Builder

[![Build](https://img.shields.io/github/actions/workflow/status/KuGouGo/OpenWrt-Builder/build.yml?branch=main&label=build)](https://github.com/KuGouGo/OpenWrt-Builder/actions/workflows/build.yml)
[![Release](https://img.shields.io/github/v/release/KuGouGo/OpenWrt-Builder?display_name=tag&label=release)](https://github.com/KuGouGo/OpenWrt-Builder/releases)
[![Upstream](https://img.shields.io/badge/upstream-OpenWrt-00b5e2)](https://github.com/openwrt/openwrt)
[![Target](https://img.shields.io/badge/target-x86%2F64-generic)](https://openwrt.org/)

Build official OpenWrt x86_64 release images with ImageBuilder.

## Layout

```txt
.github/workflows/build.yml
config/build.conf
config/packages.list
files/
packages/
README.md
```

- `config/build.conf`: build target config
- `config/packages.list`: extra packages and replacement rules
- `files/`: first-boot customizations
- `packages/`: local `.apk` files copied into ImageBuilder
- `.github/workflows/build.yml`: build workflow

## How It Works

1. Resolve the latest official OpenWrt release.
2. Download the matching ImageBuilder.
3. Download the latest upstream `sing-box` APK when `sing-box` is present in `config/packages.list`.
4. Copy `files/` and local packages into ImageBuilder.
5. Build `combined-efi.img.gz`.
6. Upload diagnostics and release assets.

## Trigger

Run `Actions -> build -> Run workflow`.

This workflow has no manual inputs. Build behavior comes from `config/build.conf`, `config/packages.list`, `files/`, and `packages/`.

## Build Config

```conf
OPENWRT_TARGET=x86
OPENWRT_SUBTARGET=64
OPENWRT_PROFILE=generic
OPENWRT_FS=squashfs
OPENWRT_IMAGES="combined-efi.img.gz"
ROOTFS_PARTSIZE=600
BUILD_BASE=https://downloads.openwrt.org
PACKAGES_FILE=config/packages.list
```

## Notes

- Uses official OpenWrt release ImageBuilder, not full source compilation
- Builds only `combined-efi.img.gz` (UEFI)
- Keeps diagnostics even on build failure
- Uses `ADD_LOCAL_KEY=1` when local packages are present
- `files/etc/uci-defaults/97-system-cn`: timezone `Asia/Shanghai` and domestic NTP servers
- `files/etc/uci-defaults/98-apk-mirror`: switch APK repositories to the USTC mirror
- `files/etc/uci-defaults/99-lan-ip`: set LAN address to `10.0.0.1/24`
- Local `.apk` files can be placed directly in `packages/`

## Download

<https://github.com/KuGouGo/OpenWrt-Builder/releases>

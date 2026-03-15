# OpenWrt Builder

[![Build](https://img.shields.io/github/actions/workflow/status/KuGouGo/OpenWrt-Builder/build.yml?branch=main&label=build)](https://github.com/KuGouGo/OpenWrt-Builder/actions/workflows/build.yml)
[![Release](https://img.shields.io/github/v/release/KuGouGo/OpenWrt-Builder?display_name=tag&label=release)](https://github.com/KuGouGo/OpenWrt-Builder/releases)
[![Upstream](https://img.shields.io/badge/upstream-OpenWrt-00b5e2)](https://github.com/openwrt/openwrt)
[![Target](https://img.shields.io/badge/target-x86%2F64-generic)](https://openwrt.org/)

Build official OpenWrt x86_64 release images with a small, release-based workflow.

## Layout

```txt
.github/workflows/build.yml
config/build.conf
config/packages.list
files/
README.md
```

- `config/build.conf`: static build target config
- `config/packages.list`: package list
- `files/`: files copied into the final image
- `.github/workflows/build.yml`: build and release pipeline

## Build flow

1. Fetch latest official OpenWrt release
2. Fetch latest stable `sing-box` OpenWrt x86_64 APK when requested
3. Load build settings from `config/build.conf`
4. Download matching official ImageBuilder
5. Copy `files/` into ImageBuilder
6. Parse `config/packages.list`
7. Build image
8. Upload diagnostics and release assets

## Trigger

Run `Actions -> build -> Run workflow`.

This workflow has no manual inputs. Build behavior comes from `config/build.conf` and `config/packages.list`.

## Build config

```conf
OPENWRT_TARGET=x86
OPENWRT_SUBTARGET=64
OPENWRT_PROFILE=generic
OPENWRT_FS=squashfs
OPENWRT_IMAGES="combined.img.gz combined-efi.img.gz"
ROOTFS_PARTSIZE=600
BUILD_BASE=https://downloads.openwrt.org
PACKAGES_FILE=config/packages.list
```

## Notes

- Targets new ImageBuilder layout (`repositories`)
- Uses official OpenWrt release ImageBuilder, not full source compilation
- Keeps diagnostics even on build failure
- Builds both `combined.img.gz` (Legacy BIOS) and `combined-efi.img.gz` (UEFI) by default
- Keeps backward compatibility with older `OPENWRT_IMAGE=...` single-image configs
- Preloads deterministic system config from `files/etc/config/`
- Rewrites APK repositories to the USTC mirror on first boot via `files/etc/uci-defaults/99-package-mirror`
- Enables a boot-time model normalization service to replace placeholder x86 DMI model names with more useful values
- If `sing-box` is present in `config/packages.list`, the workflow downloads the latest stable upstream `openwrt_x86_64.apk` release asset and injects it via ImageBuilder's local APK repository

## Download

<https://github.com/KuGouGo/OpenWrt-Builder/releases>

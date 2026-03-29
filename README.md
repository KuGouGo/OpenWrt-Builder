# OpenWrt Builder

[![Build](https://img.shields.io/github/actions/workflow/status/KuGouGo/OpenWrt-Builder/build.yml?branch=main&label=build)](https://github.com/KuGouGo/OpenWrt-Builder/actions/workflows/build.yml)
[![Release](https://img.shields.io/github/v/release/KuGouGo/OpenWrt-Builder?display_name=tag&label=release)](https://github.com/KuGouGo/OpenWrt-Builder/releases)
[![Upstream](https://img.shields.io/badge/upstream-OpenWrt-00b5e2)](https://github.com/openwrt/openwrt)
[![Target](https://img.shields.io/badge/target-x86%2F64-generic)](https://openwrt.org/)

Build polished OpenWrt x86_64 release images with the official ImageBuilder.

This repository automates a small, opinionated OpenWrt build pipeline for `x86/64` UEFI systems. It tracks the latest upstream release, applies local customizations, bundles optional packages, and publishes ready-to-use images through GitHub Actions.

## Repository Layout

```txt
.github/workflows/build.yml
config/build.conf
config/packages.list
files/
packages/
README.md
```

- `config/build.conf`: target, image, and download settings
- `config/packages.list`: extra packages and explicit package replacements
- `files/`: first-boot files and UCI defaults copied into the image
- `packages/`: local `.apk` files injected into ImageBuilder before packaging
- `.github/workflows/build.yml`: the end-to-end GitHub Actions workflow

## What The Workflow Does

1. Resolve the latest official OpenWrt release.
2. Download the matching ImageBuilder.
3. Fetch the latest upstream `sing-box` APK when `sing-box` is listed in `config/packages.list`.
4. Copy the `files/` overlay and local packages into ImageBuilder.
5. Build the `combined-efi.img.gz` image.
6. Publish diagnostics, manifests, and release assets.

## Running A Build

Run `Actions -> build -> Run workflow` in GitHub.

There are no manual workflow inputs. Build behavior is fully driven by `config/build.conf`, `config/packages.list`, `files/`, and `packages/`.

## Build Configuration

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

## Project Notes

- Uses the official OpenWrt release ImageBuilder rather than a full source build
- Produces the `combined-efi.img.gz` image for UEFI deployments
- Preserves diagnostics even when the build fails
- Enables `ADD_LOCAL_KEY=1` automatically when local packages are present
- Keeps x86/64 generic profile defaults implicit in `config/packages.list`, including common NIC drivers
- `files/etc/uci-defaults/97-system-cn`: sets timezone to `Asia/Shanghai` and switches to domestic NTP servers
- `files/etc/uci-defaults/98-apk-mirror`: rewrites APK repositories to the USTC mirror
- `files/etc/uci-defaults/99-lan-ip`: changes the LAN address to `10.0.0.1/24`
- `files/etc/rc.local`: updates `/tmp/sysinfo/model` on every boot when DMI `product_name` matches `Default string`
- Local `.apk` files can be dropped directly into `packages/`

## Download

<https://github.com/KuGouGo/OpenWrt-Builder/releases>

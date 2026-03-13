# openwrt-builder

[![Build](https://img.shields.io/github/actions/workflow/status/KuGouGo/openwrt-builder/build.yml?branch=main&label=build)](https://github.com/KuGouGo/openwrt-builder/actions/workflows/build.yml)
[![Release](https://img.shields.io/github/v/release/KuGouGo/openwrt-builder?display_name=tag&label=release)](https://github.com/KuGouGo/openwrt-builder/releases)
[![Upstream](https://img.shields.io/badge/upstream-OpenWrt-00b5e2)](https://github.com/openwrt/openwrt)
[![Target](https://img.shields.io/badge/target-x86%2F64-generic)](https://openwrt.org/)

Build official OpenWrt x86_64 release images with a small set of practical customizations.

## Usage

1. Edit package list: `cfg/pkgs.txt`
2. Edit system config: `files/etc/config/system`
3. Run workflow: `Actions -> build -> Run workflow`
4. Download image from `Releases`

## Files

```txt
.github/workflows/build.yml
cfg/pkgs.txt
files/etc/config/system
files/etc/defaults/10-model
scripts/tune.sh
```

## Download

<https://github.com/KuGouGo/openwrt-builder/releases>

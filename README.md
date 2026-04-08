# OpenWrt Builder

[![Build](https://img.shields.io/github/actions/workflow/status/KuGouGo/OpenWrt-Builder/build.yml?branch=main&label=build)](https://github.com/KuGouGo/OpenWrt-Builder/actions/workflows/build.yml)
[![Release](https://img.shields.io/github/v/release/KuGouGo/OpenWrt-Builder?display_name=tag&label=release)](https://github.com/KuGouGo/OpenWrt-Builder/releases)
[![Upstream](https://img.shields.io/badge/upstream-OpenWrt-00b5e2)](https://github.com/openwrt/openwrt)
[![Target](https://img.shields.io/badge/target-x86%2F64-generic)](https://openwrt.org/)

基于官方 ImageBuilder 自动构建 OpenWrt x86_64 镜像，每次触发自动跟进最新上游版本。

## 使用

进入 `Actions → build → Run workflow` 触发构建，无需手动输入。构建完成后镜像发布到 [Releases](https://github.com/KuGouGo/OpenWrt-Builder/releases)。

## 配置

`config/build.conf` — 目标平台和镜像参数：

```conf
OPENWRT_TARGET=x86
OPENWRT_SUBTARGET=64
OPENWRT_PROFILE=generic
OPENWRT_FS=squashfs
OPENWRT_IMAGES="combined-efi.img.gz"
ROOTFS_PARTSIZE=1024
BUILD_BASE=https://downloads.openwrt.org
PACKAGES_FILE=config/packages.list
```

`config/packages.list` — 额外安装的包及需移除的默认包（`-` 前缀表示移除）。

`files/` — 覆盖到镜像的初始化文件和 UCI defaults，在首次启动时执行：
- `95-apk-immortalwrt`：自动匹配可用的 ImmortalWrt APK 源，不可用时移除该覆盖源
- `96-local-tools`：确保本地工具脚本可执行
- `97-system-cn`：时区设为 Asia/Shanghai，NTP 切换为国内服务器
- `98-apk-mirror`：APK 源替换为 USTC 镜像

`packages/` — 本地 `.apk` 文件，构建时注入 ImageBuilder。

## 内置工具

`/usr/bin/sb` — sing-box 管理助手，支持核心升级和配置更新。

```
sb                        # 交互式菜单（终端模式）或自动更新（非终端）
sb core                   # 仅更新核心到最新 Release
sb config URL             # 使用指定 URL 更新配置（不保存）
sb set-url URL            # 保存配置订阅地址
sb show-url               # 查看当前保存的订阅地址
sb status                 # 查看当前状态
```

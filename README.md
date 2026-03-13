# openwrt-builder

一个尽量省心的 **官方 OpenWrt x86_64 自动构建仓库**。

它做的事情很克制：

- 只跟 **官方最新发行版**
- 只做 **x86_64 / generic**
- 只保留最后真正要用的那个镜像
- 只在你**手动运行**时构建
- 只做少量、明确、可维护的定制

如果你想要的是：**官方味道尽量不变，但又想顺手带上自己的包和基础配置**，这套就很合适。

---

## 这仓库现在会产出什么

最终只发布一个文件到 **GitHub Releases**：

```txt
openwrt-<version>-x86-64-generic-squashfs-combined-efi.img.gz
```

例如：

```txt
openwrt-25.12.0-x86-64-generic-squashfs-combined-efi.img.gz
```

命名风格尽量贴近官方，不额外整花活。

---

## 构建策略

这套仓库走的是：

**官方 release → 官方 ImageBuilder → 你的少量定制 → 发布到 Release**

不是：

- snapshot
- master/main 源码日编
- ImmortalWrt / LEDE 分支魔改
- 重型全量源码编译流

这么做的好处很实际：

- **快**：ImageBuilder 比完整源码编译轻很多
- **稳**：跟官方发行版走，坑少一截
- **省心**：后期维护基本只改几个文件
- **结果干净**：只留最终镜像，不堆一堆附件

---

## 当前默认配置

- **Target**: `x86/64`
- **Profile**: `generic`
- **Filesystem**: `squashfs`
- **Image**: `combined-efi.img.gz`
- **Timezone**: `Asia/Shanghai`
- **Rootfs partsize**: `600`
- **Kernel partsize**: `32`
- **Mirror**: `Tsinghua Tuna`
- **Trigger**: `workflow_dispatch`（手动运行）

---

## 仓库结构

```txt
.github/workflows/build.yml   GitHub Actions 构建与发布逻辑
cfg/pkgs.txt                  软件包列表（每行一个）
files/etc/config/system       系统时区、NTP、主机名等配置
files/etc/defaults/10-model   x86 设备型号名修正
scripts/tune.sh               预留的自定义调整脚本
```

如果平时只改常用内容，你大概率只会碰这三个：

- `cfg/pkgs.txt`
- `files/etc/config/system`
- `.github/workflows/build.yml`

---

## 怎么用

### 1）修改软件包

包列表放在：

```txt
cfg/pkgs.txt
```

规则很简单：

- 一行一个包
- 支持空行
- 支持注释行
- 支持移除默认包

比如：

```txt
dnsmasq-full
-dnsmasq
```

这表示：

- 安装 `dnsmasq-full`
- 移除默认的 `dnsmasq`

---

### 2）调整系统配置

默认时区和 NTP 在这里：

```txt
files/etc/config/system
```

目前已经预设：

- `Asia/Shanghai`
- `CST-8`
- 阿里云 / 腾讯的 NTP 服务器

---

### 3）手动运行构建

去仓库的 **Actions** 页面，选中：

```txt
build
```

然后点 **Run workflow** 就行。

这套配置现在是**纯手动触发**：

- 不会因为 push 自动编译
- 不会定时偷偷跑
- 不会提交一下就开始烧 Actions 配额

---

## 构建完成后会发生什么

工作流会自动：

1. 获取官方最新 release
2. 下载对应版本的官方 ImageBuilder
3. 写入国内软件源配置
4. 读取 `cfg/pkgs.txt` 中的软件包
5. 构建 x86_64 `generic` 镜像
6. 从产物里挑出最终 EFI 镜像
7. 统一整理成官方风格命名
8. 上传到当前仓库的 **Releases**

默认不会保留一堆杂物，比如：

- `manifest`
- `buildinfo`
- `sha256sums`
- `json`
- 其他不需要的镜像格式

整个思路就一句话：**只留下你真正会下载的那个文件。**

---

## 国内镜像源

默认使用清华 Tuna：

```txt
https://mirrors.tuna.tsinghua.edu.cn/openwrt
```

构建时会自动把对应 release 的 apk 源写进固件里。  
以后如果你想换成别的镜像，只需要改 workflow 里的：

```txt
MIRROR_BASE
```

---

## 额外的小定制

### 时区
已经设为：

- `Asia/Shanghai`
- `CST-8`

### 型号名修正
有些 x86 设备在 LuCI 里会把型号显示成很蠢的：

```txt
Default string
```

这里加了一点小修正逻辑：

如果检测到这个值，就把展示名改成：

```txt
OpenWrt Router
```

对应文件：

```txt
files/etc/defaults/10-model
```

不是什么大功能，但看着顺眼很多。

---

## 为什么不用完整源码编译

因为对这个仓库的目标来说，没必要上重武器。

你现在要的是：

- 官方发行版底子
- x86_64
- 少量包
- 少量配置
- 快速、稳定、可重复地产出镜像

那 ImageBuilder 就是更合理的方案。

如果以后真要上：

- 第三方源码包移植
- 深度补丁
- 自己改 target
- 大量底层裁剪

那时候再切完整源码编译也不迟。

---

## 维护建议

日常维护尽量保持克制：

### 优先做这些
- 调整 `cfg/pkgs.txt`
- 改 overlay 配置
- 改少量 workflow 逻辑

### 尽量少做这些
- 跨发行版搬包
- 塞一堆非官方补丁
- 把仓库折腾成大杂烩

这仓库的价值，不在于功能堆得多，而在于：

**它能一直稳定地产出你想要的官方风格固件。**

---

## 最后

如果 workflow 报错，先看两类东西：

- 包名是不是在当前官方 release 里还存在
- 上游 ImageBuilder 文件名/目录结构有没有变化

这两类问题最常见，也最好修。

剩下的，真炸了再拆。
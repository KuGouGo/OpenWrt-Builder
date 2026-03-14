#!/usr/bin/env bash
set -euo pipefail

IMAGEBUILDER_DIR="${1:-imagebuilder}"
RELEASE_VERSION="${2:-unknown}"

echo "Custom hook running for OpenWrt ${RELEASE_VERSION} in ${IMAGEBUILDER_DIR}"

# Add Nikki feed repository (for x86_64)
# Users can install nikki packages via: apk update && apk add nikki
# Note: SNAPSHOT packages may have dependency conflicts with stable releases
REPOS_CONF="${IMAGEBUILDER_DIR}/repositories.conf"
if [ -f "$REPOS_CONF" ]; then
  # Determine Nikki branch based on OpenWrt version
  case "$RELEASE_VERSION" in
    24.10*|25.12*)
      # Use SNAPSHOT branch (only available option)
      echo "" >> "$REPOS_CONF"
      echo "# Nikki feed repository" >> "$REPOS_CONF"
      echo "# Note: SNAPSHOT packages may require matching SNAPSHOT OpenWrt" >> "$REPOS_CONF"
      echo "# src/gz nikki https://nikkinikki.pages.dev/SNAPSHOT/x86_64/nikki" >> "$REPOS_CONF"
      ;;
  esac
  echo "Updated repositories.conf with Nikki feed (commented out by default)"
fi

# 这里可以按需加自定义逻辑，例如：
# - 替换默认 IP
# - 写入自定义 banner
# - 复制额外配置
# - 调整默认主题

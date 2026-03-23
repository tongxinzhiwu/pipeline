#!/bin/bash

set -e
trap 'rm -f pipeline.tar.gz; rm -rf pipeline-*-*' EXIT

VERSION=""

GITHUB_ORG="tongxinzhiwu"
GITHUB_REPO="pipeline"

OS=$(uname -s | tr '[:upper:]' '[:lower:]')
ARCH=$(uname -m | tr '[:upper:]' '[:lower:]')

echo [INFO] OS=$OS
echo [INFO] ARCH=$ARCH

# adapt windows
if [[ "$OS" =~ msys* ]] || [[ "$OS" =~ mingw* ]] || [[ "$OS" =~ cygwin* ]] || [[ "$OS" =~ windows* ]]; then
  OS="windows"
fi

if [ "x86_64" = "$ARCH" ]; then
  ARCH="amd64"
fi

if [ "aarch64" = "$ARCH" ]; then
  ARCH="arm64"
fi

if [ "armv7l" = "$ARCH" ]; then
  ARCH="armv7"
fi

# check if curl is installed
if ! command -v curl &> /dev/null; then
    echo "curl could not be found"
    exit 1
fi

# if not specified, get the latest version
if [ -z "$VERSION" ]; then
  VERSION=$(curl --silent "https://api.github.com/repos/$GITHUB_ORG/$GITHUB_REPO/releases/latest" | grep '"tag_name":' | sed -E 's/.*"([^"]+)".*/\1/')
fi

# download pipeline cli
DOWNLOAD_URL="https://github.com/$GITHUB_ORG/$GITHUB_REPO/releases/download/$VERSION/pipeline-$OS-$ARCH.tar.gz"
echo [INFO] Downloading pipeline...
echo [INFO] URL: "$DOWNLOAD_URL"

curl -fSL -o pipeline.tar.gz "$DOWNLOAD_URL"

# extract pipeline
echo [INFO] Extracting pipeline...
tar -xzf pipeline.tar.gz

# install pipeline
echo [INFO] Installing pipeline...

PIPELINE_BIN="pipeline-$OS-$ARCH/pipeline"

# if is windows, add .exe
if [ "$OS" = "windows" ]; then
  PIPELINE_BIN="$PIPELINE_BIN.exe"
fi

chmod +x "$PIPELINE_BIN"

# install to /usr/local/bin (falls back to ~/.pipeline if no permission)
BIN_PATH="/usr/local/bin"
if [ -w "$BIN_PATH" ]; then
  mv "$PIPELINE_BIN" "$BIN_PATH/pipeline"
else
  echo "[INFO] No write permission to $BIN_PATH, trying with sudo..."
  sudo mv "$PIPELINE_BIN" "$BIN_PATH/pipeline"
fi

# version
echo "[INFO] $(pipeline --version)"

# done
echo "[INFO] Installation complete. Run 'pipeline --help' to get started."

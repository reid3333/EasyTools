#!/bin/bash
set -e

# Civitai からZIPを取得して展開するラッパー
# 使い方: bash civitai_model_download_unzip.sh <DOWNLOAD_DIR> <DOWNLOAD_FILE> <MODEL_ID> <VERSION_ID>

DOWNLOAD_DIR="$1"
DOWNLOAD_FILE="$2"
DOWNLOAD_ZIP_FILE="$(basename "$DOWNLOAD_FILE" .zip).zip"
MODEL_ID="$3"
VERSION_ID="$4"

if [ -z "$DOWNLOAD_DIR" ] || [ -z "$DOWNLOAD_FILE" ] || [ -z "$MODEL_ID" ] || [ -z "$VERSION_ID" ]; then
  echo "[ERROR] 使用法: $0 <DOWNLOAD_DIR> <DOWNLOAD_FILE> <MODEL_ID> <VERSION_ID>"
  exit 1
fi

SCRIPT_DIR="$(dirname -- "$(realpath -- "${BASH_SOURCE[0]}")")"

TARGET_PATH="${DOWNLOAD_DIR%/}/${DOWNLOAD_FILE}"

if [ -f "$TARGET_PATH" ]; then
  if [ -f "${SCRIPT_DIR}/../Download/ARIA_USE_CURL" ] || [ ! -f "${TARGET_PATH}.aria2" ]; then
    MODEL_URL="https://civitai.com/models/${MODEL_ID}?modelVersionId=${VERSION_ID}"
    echo "$MODEL_URL $DOWNLOAD_FILE"
    exit 0
  fi
fi

"$SCRIPT_DIR/civitai_model_download.sh" "$DOWNLOAD_DIR" "$DOWNLOAD_ZIP_FILE" "$MODEL_ID" "$VERSION_ID"

ZIP_PATH="${DOWNLOAD_DIR%/}/${DOWNLOAD_ZIP_FILE}"

if ! command -v unzip >/dev/null 2>&1; then
  echo "[ERROR] unzip コマンドが見つかりません。'sudo apt install -y unzip' を実行してください。"
  exit 1
fi

echo "[INFO] 展開中: $ZIP_PATH -> ${DOWNLOAD_DIR%/}"
unzip -o "$ZIP_PATH" -d "${DOWNLOAD_DIR%/}" >/dev/null

rm -f "$ZIP_PATH"


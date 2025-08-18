#!/bin/bash
set -e

# Civitai からモデルをダウンロード
# 使い方: bash civitai_model_download.sh <DOWNLOAD_DIR> <DOWNLOAD_FILE> <MODEL_ID> <VERSION_ID>

DOWNLOAD_DIR="$1"
DOWNLOAD_FILE="$2"
MODEL_ID="$3"
VERSION_ID="$4"

if [ -z "$DOWNLOAD_DIR" ] || [ -z "$DOWNLOAD_FILE" ] || [ -z "$MODEL_ID" ] || [ -z "$VERSION_ID" ]; then
  echo "[ERROR] 使用法: $0 <DOWNLOAD_DIR> <DOWNLOAD_FILE> <MODEL_ID> <VERSION_ID>"
  exit 1
fi

SCRIPT_DIR="$(dirname -- "$(realpath -- "${BASH_SOURCE[0]}")")"

"$SCRIPT_DIR/civitai_api_key.sh"

API_KEY_FILE="${SCRIPT_DIR}/CivitaiApiKey.txt"
if [ ! -f "$API_KEY_FILE" ]; then
  echo "[ERROR] API Key ファイルが見つかりません: $API_KEY_FILE"
  exit 1
fi

CIVITAI_API_KEY=$(head -n 1 "$API_KEY_FILE")

MODEL_URL="https://civitai.com/models/${MODEL_ID}?modelVersionId=${VERSION_ID}"
echo "$MODEL_URL $DOWNLOAD_FILE"

DOWNLOAD_URL="https://civitai.com/api/download/models/${VERSION_ID}?token=${CIVITAI_API_KEY}"
"${SCRIPT_DIR}/../Download/aria.sh" "$DOWNLOAD_DIR" "$DOWNLOAD_FILE" "$DOWNLOAD_URL"


#!/bin/bash
set -e

# 単一ファイルをHugging Faceからダウンロードするラッパー
# 使い方: bash hugging_face.sh <DOWNLOAD_DIR> <DOWNLOAD_FILE> <REPO_ID> <REPO_DIR>

DOWNLOAD_DIR="$1"
DOWNLOAD_FILE="$2"
REPO_ID="$3"
REPO_DIR="$4"

if [ -z "$DOWNLOAD_DIR" ] || [ -z "$DOWNLOAD_FILE" ] || [ -z "$REPO_ID" ]; then
  echo "[ERROR] 使用法: $0 <DOWNLOAD_DIR> <DOWNLOAD_FILE> <REPO_ID> <REPO_DIR>"
  exit 1
fi

REPO_DIR_PREFIX="${REPO_DIR}"

HF_MODEL_CARD="https://huggingface.co/${REPO_ID}"
HF_DOWNLOAD_URL="${HF_MODEL_CARD}/resolve/main/${REPO_DIR_PREFIX}${DOWNLOAD_FILE}"

echo "$HF_MODEL_CARD ${REPO_DIR_PREFIX}${DOWNLOAD_FILE}"

SCRIPT_DIR="$(dirname -- "$(realpath -- "${BASH_SOURCE[0]}")")"
"$SCRIPT_DIR/aria.sh" "$DOWNLOAD_DIR" "$DOWNLOAD_FILE" "$HF_DOWNLOAD_URL"


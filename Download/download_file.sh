#!/bin/bash
set -e

# ファイルをダウンロードします。aria2c があれば並列で、なければ curl で実行します。
# 使い方: bash download_file.sh <url> [output_path]

if [ -z "$1" ]; then
  echo "[ERROR] 使用法: $0 <url> [output_path]"
  exit 1
fi

URL="$1"
OUT="$2"

mkdir -p "$(dirname "${OUT:-./_tmp}")" 2>/dev/null || true

if command -v aria2c >/dev/null 2>&1; then
  echo "[INFO] aria2c でダウンロードします: $URL"
  if [ -n "$OUT" ]; then
    aria2c -x16 -s16 -k1M -c -o "$(basename "$OUT")" -d "$(dirname "$OUT")" "$URL"
  else
    aria2c -x16 -s16 -k1M -c "$URL"
  fi
elif command -v curl >/dev/null 2>&1; then
  echo "[INFO] curl でダウンロードします: $URL"
  if [ -n "$OUT" ]; then
    curl -L -C - -o "$OUT" "$URL"
  else
    curl -L -O "$URL"
  fi
else
  echo "[ERROR] aria2c か curl のいずれかが必要です。'sudo apt install -y aria2 curl' を実行してください。"
  exit 1
fi

echo "[INFO] ダウンロード完了"


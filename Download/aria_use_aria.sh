#!/bin/bash
set -e
SCRIPT_DIR="$(dirname -- "$(realpath -- "${BASH_SOURCE[0]}")")"
if [ -f "$SCRIPT_DIR/ARIA_USE_CURL" ]; then
  rm -f "$SCRIPT_DIR/ARIA_USE_CURL"
fi
echo "[INFO] ARIA_USE_CURL フラグを無効化しました（aria2を使用）。"


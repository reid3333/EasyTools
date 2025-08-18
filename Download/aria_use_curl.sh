#!/bin/bash
set -e
SCRIPT_DIR="$(dirname -- "$(realpath -- "${BASH_SOURCE[0]}")")"
touch "$SCRIPT_DIR/ARIA_USE_CURL"
echo "[INFO] ARIA_USE_CURL フラグを有効化しました。"


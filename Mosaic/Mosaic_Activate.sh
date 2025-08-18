#!/bin/bash
set -e

cd "$(dirname "$0")"
MOSAIC=mosaic_20240601

if [ ! -f "$MOSAIC/venv/bin/activate" ]; then
  echo "[ERROR] $MOSAIC/venv/bin/activate が見つかりません。まず Update を実行してください。"
  exit 1
fi

# shellcheck disable=SC1091
source "$MOSAIC/venv/bin/activate"
exec "$SHELL"


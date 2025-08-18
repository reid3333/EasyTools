#!/bin/bash
set -e

SCRIPT_DIR=$(cd "$(dirname "$0")" && pwd)
MOSAIC="mosaic_20240601"

pushd "$SCRIPT_DIR" >/dev/null

echo "https://wikiwiki.jp/sd_toshiaki/%E3%82%88%E3%81%8F%E3%81%82%E3%82%8B%E8%B3%AA%E5%95%8F#je61f50a"

ZIP="${MOSAIC}.zip"
URL="https://cdn.wikiwiki.jp/to/w/sd_toshiaki/%E3%82%88%E3%81%8F%E3%81%82%E3%82%8B%E8%B3%AA%E5%95%8F/::attach/${MOSAIC}.zip"

curl -L -o "$ZIP" "$URL"

if ! command -v unzip >/dev/null 2>&1; then
  echo "[ERROR] unzip コマンドが見つかりません。'sudo apt install -y unzip' を実行してください。"
  exit 1
fi

unzip -o "$ZIP" -d "$MOSAIC" >/dev/null
rm -f "$ZIP"

popd >/dev/null

pushd "${SCRIPT_DIR}/${MOSAIC}" >/dev/null

"${SCRIPT_DIR}/../Python/python_activate.sh" venv >/dev/null || true
if [ -f venv/bin/activate ]; then
  # shellcheck disable=SC1091
  source venv/bin/activate
fi

python -m pip install -qq -U pip setuptools wheel
pip install -qq pillow==11.1.0 piexif==1.1.3

popd >/dev/null

echo "[INFO] Mosaic の更新が完了しました。"


#!/bin/bash
set -e

SCRIPT_DIR="$(dirname -- "$(realpath -- "${BASH_SOURCE[0]}")")"
EASY_DIR="${SCRIPT_DIR}/.."

# 取得（ハッシュ指定なし）
"${EASY_DIR}/Git/github_clone_or_pull_hash.sh" nekotodance SdImageDiet main

pushd "${SCRIPT_DIR}/SdImageDiet" >/dev/null

"${EASY_DIR}/Python/python_activate.sh" venv >/dev/null || true
if [ -f venv/bin/activate ]; then
  # shellcheck disable=SC1091
  source venv/bin/activate
fi

python -m pip install -qq -U pip setuptools wheel
pip install -qq PyQt5==5.15.11 Image==1.5.33 piexif==1.1.3 pillow-avif-plugin==1.4.6 || true

popd >/dev/null

echo "[INFO] SdImageDiet の更新が完了しました。"


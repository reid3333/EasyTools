#!/bin/bash
set -e

SCRIPT_DIR="$(dirname -- "$(realpath -- "${BASH_SOURCE[0]}")")"
EASY_DIR="${SCRIPT_DIR}/.."

# 取得
"${EASY_DIR}/Git/github_clone_or_pull.sh" zanllp sd-webui-infinite-image-browsing main

pushd "${SCRIPT_DIR}/sd-webui-infinite-image-browsing" >/dev/null

# venv 準備と有効化
"${EASY_DIR}/Python/python_activate.sh" venv >/dev/null || true
if [ -f venv/bin/activate ]; then
  # shellcheck disable=SC1091
  source venv/bin/activate
fi

python -m pip install -qq -U pip setuptools wheel
pip install -qq -r requirements.txt

popd >/dev/null

echo "[INFO] InfiniteImageBrowsing の更新が完了しました。"


#!/bin/bash
set -e

SCRIPT_DIR="$(dirname -- "$(realpath -- "${BASH_SOURCE[0]}")")"
EASY_DIR="${SCRIPT_DIR}/.."

# 取得（ハッシュ指定なしの場合は最新）
"${EASY_DIR}/Git/github_clone_or_pull_hash.sh" Zuntan03 GenImageViewer main

echo "[INFO] GenImageViewer の取得/更新が完了しました。"


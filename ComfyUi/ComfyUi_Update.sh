#!/bin/bash
set -e

SCRIPT_DIR=$(cd "$(dirname "$0")" && pwd)
EASY_DIR="${SCRIPT_DIR}/.."

# バージョン指定（任意）
COMFY_VERSION_FILE="${SCRIPT_DIR}/ComfyUi_Version.txt"
COMFY_TAG=""
if [ -f "$COMFY_VERSION_FILE" ]; then
  COMFY_TAG=$(head -n 1 "$COMFY_VERSION_FILE")
fi

# 本体取得
if [ -n "$COMFY_TAG" ]; then
  "${EASY_DIR}/Git/github_clone_or_pull_tag.sh" comfyanonymous ComfyUI master "$COMFY_TAG"
else
  "${EASY_DIR}/Git/github_clone_or_pull.sh" comfyanonymous ComfyUI master
fi

pushd "${SCRIPT_DIR}/ComfyUI" >/dev/null

"${EASY_DIR}/Python/python_activate.sh" venv >/dev/null || true
if [ -f venv/bin/activate ]; then
  # shellcheck disable=SC1091
  source venv/bin/activate
fi

python -m pip install -qq -U pip setuptools wheel

if [ -f requirements.txt ]; then
  pip install -qq -r requirements.txt || true
fi

popd >/dev/null

# ComfyUI-Manager（任意）
CUSTOM_NODES_DIR="${SCRIPT_DIR}/ComfyUI/custom_nodes"
mkdir -p "$CUSTOM_NODES_DIR"
MANAGER_VERSION_FILE="${SCRIPT_DIR}/ComfyUiManager_Version.txt"
MANAGER_TAG=""
if [ -f "$MANAGER_VERSION_FILE" ]; then
  MANAGER_TAG=$(head -n 1 "$MANAGER_VERSION_FILE")
fi

pushd "$CUSTOM_NODES_DIR" >/dev/null
if [ -n "$MANAGER_TAG" ]; then
  "${EASY_DIR}/Git/github_clone_or_pull_tag.sh" Comfy-Org ComfyUI-Manager main "$MANAGER_TAG"
else
  "${EASY_DIR}/Git/github_clone_or_pull.sh" Comfy-Org ComfyUI-Manager main
fi
popd >/dev/null

echo "[INFO] ComfyUI の更新が完了しました。"


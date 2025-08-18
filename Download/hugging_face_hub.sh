#!/bin/bash
set -e

# huggingface_hub を用いたスナップショットダウンロードのラッパー
# 使い方: bash hugging_face_hub.sh <local_dir> <repo_id> <repo_type> [<allow_patterns>...]

SCRIPT_DIR=$(cd "$(dirname "$0")" && pwd)
ENV_DIR="${SCRIPT_DIR}/env"

mkdir -p "$ENV_DIR"

# 仮想環境の作成（有効化は自前で行う）
"${SCRIPT_DIR}/../Python/python_activate.sh" "$ENV_DIR" >/dev/null || true

# 有効化
if [ -f "${ENV_DIR}/bin/activate" ]; then
  # shellcheck disable=SC1091
  source "${ENV_DIR}/bin/activate"
else
  echo "[ERROR] 仮想環境の有効化に失敗しました: ${ENV_DIR}/bin/activate がありません"
  exit 1
fi

python -m pip install -qq -U pip setuptools wheel
pip install -qq huggingface_hub

python "${SCRIPT_DIR}/hugging_face_hub.py" "$@"


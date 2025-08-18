#!/bin/bash
set -e

SCRIPT_DIR="$(dirname -- "$(realpath -- "${BASH_SOURCE[0]}")")"

pushd "$SCRIPT_DIR" >/dev/null

"${SCRIPT_DIR}/../Python/python_activate.sh" venv >/dev/null || true
if [ -f venv/bin/activate ]; then
  # shellcheck disable=SC1091
  source venv/bin/activate
fi

python -m pip install -qq -U pip setuptools wheel

# Linux では環境に応じて torch のバージョンが異なるため、requirements のみ先に適用
if [ -f requirements.txt ]; then
  pip install -qq -r requirements.txt || true
fi

echo "[INFO] 必要に応じて PyTorch を手動インストールしてください (CUDA/CPU)。例: pip install torch torchvision --index-url https://download.pytorch.org/whl/cu124"

popd >/dev/null

echo "[INFO] LamaCleaner の更新が完了しました。"


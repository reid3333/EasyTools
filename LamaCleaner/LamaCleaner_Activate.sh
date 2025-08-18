#!/bin/bash
set -e

cd "$(dirname "$0")"

if [ ! -f venv/bin/activate ]; then
  echo "[ERROR] venv/bin/activate が見つかりません。まず Update を実行してください。"
  exit 1
fi

# shellcheck disable=SC1091
source venv/bin/activate
exec "$SHELL"


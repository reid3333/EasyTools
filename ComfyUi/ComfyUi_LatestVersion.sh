#!/bin/bash
set -e

API="https://api.github.com/repos/comfyanonymous/ComfyUI/releases/latest"
JSON=$(curl -sSL "$API")

if [ -z "$JSON" ]; then
  echo "[ERROR] ComfyUI の最新バージョン情報の取得に失敗しました。"
  exit 1
fi

TAG=$(python3 - <<'PY'
import json,sys
data=json.load(sys.stdin)
print(data.get('tag_name',''))
PY
<<<"$JSON")

if [ -z "$TAG" ]; then
  echo "[ERROR] tag_name の抽出に失敗しました。"
  exit 1
fi

echo "$TAG" > "$(dirname "$0")/ComfyUi_Version.txt"
echo "ComfyUI $TAG"


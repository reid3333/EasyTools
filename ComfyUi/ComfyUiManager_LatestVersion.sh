#!/bin/bash
set -e

API="https://api.github.com/repos/Comfy-Org/ComfyUI-Manager/tags"
JSON=$(curl -sSL "$API")

if [ -z "$JSON" ]; then
  echo "[ERROR] ComfyUI-Manager の最新バージョン情報の取得に失敗しました。"
  exit 1
fi

TAG=$(python3 - <<'PY'
import json,sys
data=json.load(sys.stdin)
if isinstance(data, list) and data:
    print(data[0].get('name',''))
else:
    print('')
PY
<<<"$JSON")

if [ -z "$TAG" ]; then
  echo "[ERROR] タグ名の抽出に失敗しました。"
  exit 1
fi

echo "$TAG" > "$(dirname "$0")/ComfyUiManager_Version.txt"
echo "ComfyUI-Manager $TAG"


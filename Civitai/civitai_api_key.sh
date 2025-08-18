#!/bin/bash
set -e

# Civitai API Key を保存するヘルパー
# 使い方: bash civitai_api_key.sh

SCRIPT_DIR=$(cd "$(dirname "$0")" && pwd)
API_KEY_FILE="${SCRIPT_DIR}/CivitaiApiKey.txt"

if [ -f "$API_KEY_FILE" ]; then
  exit 0
fi

echo "Civitai のアカウント設定から API Key をコピー＆ペーストしてください。"
echo "Civitai API Key を ${API_KEY_FILE} に保存します。"
echo
echo "1. ブラウザで開く: https://civitai.com/user/account"
echo "2. [API Keys] => [Add API key]"
echo "3. [Name] easy => [Save]"
echo "4. 生成された API Key をコピーして、以下に貼り付け"

read -r -p "Civitai API Key: " INPUT_KEY
if [ -z "$INPUT_KEY" ]; then
  echo "[ERROR] Civitai API Key が空欄です。"
  exit 1
fi

echo "保存先: $API_KEY_FILE"
printf "%s\n" "$INPUT_KEY" > "$API_KEY_FILE"


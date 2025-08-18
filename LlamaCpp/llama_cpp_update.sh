#!/bin/bash
# llama.cppのアップデート（Ubuntuバイナリをダウンロード・展開）

# スクリプトがあるディレクトリに移動
cd "$(dirname "$0")" || exit 1

# 共通スクリプトのパス
ARIA_SH="../Download/aria.sh"

# デフォルトのバージョン
LLAMA_CPP_DEFAULT_VERSION="b6191"
VERSION_FILE="LlamaCpp_Version.txt"
DEST_DIR="LlamaCpp"

# バージョンファイルの確認と読み込み
if [ ! -f "$VERSION_FILE" ]; then
    echo "$LLAMA_CPP_DEFAULT_VERSION" > "$VERSION_FILE"
fi
LLAMA_CPP_VERSION=$(cat "$VERSION_FILE")

# ZIPファイル名とURLを構築
LLAMA_CPP_ZIP="llama-${LLAMA_CPP_VERSION}-bin-ubuntu-x64.zip"
LLAMA_CPP_URL="https://github.com/ggml-org/llama.cpp/releases/download/${LLAMA_CPP_VERSION}/${LLAMA_CPP_ZIP}"

# 既にディレクトリが存在する場合は処理をスキップ
if [ -d "$DEST_DIR" ]; then
    echo "Directory '$DEST_DIR' already exists. Skipping download and extraction."
    exit 0
fi

# ダウンロードの実行
echo "Downloading llama.cpp version: $LLAMA_CPP_VERSION"
bash "$ARIA_SH" "./" "$LLAMA_CPP_ZIP" "$LLAMA_CPP_URL"
if [ $? -ne 0 ]; then
    echo "Error: Failed to download $LLAMA_CPP_ZIP."
    exit 1
fi

# ZIPファイルの展開
echo "Extracting $LLAMA_CPP_ZIP..."
unzip -o "$LLAMA_CPP_ZIP" -d "$DEST_DIR"
if [ $? -ne 0 ]; then
    echo "Error: Failed to extract $LLAMA_CPP_ZIP."
    # 失敗した場合はダウンロードしたZIPファイルを残す
    exit 1
fi

# ZIPファイルの削除
rm -f "$LLAMA_CPP_ZIP"

echo "llama.cpp has been successfully installed."
exit 0

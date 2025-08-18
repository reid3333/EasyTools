#!/bin/bash
# このスクリプトは、LlamaCppサーバーを起動します。

# スクリプトのディレクトリを取得
SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"

# LlamaCppディレクトリのパス
LLAMA_CPP_DIR="$SCRIPT_DIR/LlamaCpp/LlamaCpp"

# LlamaCppがセットアップされているか確認
if [ ! -d "$LLAMA_CPP_DIR/" ]; then
    echo "LlamaCppが見つかりません。セットアップを実行します..."
    bash "$SCRIPT_DIR/LlamaCpp/llama_cpp_update.sh"
fi

# 再度確認し、それでも存在しない場合はエラー終了
if [ ! -d "$LLAMA_CPP_DIR/" ]; then
    echo "エラー: LlamaCppのセットアップに失敗しました。"
    echo "$LLAMA_CPP_DIR/ が見つかりません。"
    read -p "Enterキーを押して終了します..."
    exit 1
fi

# LlamaCppディレクトリに移動
cd "$LLAMA_CPP_DIR"

# サーバーを起動
echo "サーバーを起動します: ./llama-server $@"
./llama-server "$@"

# エラーチェック
if [ $? -ne 0 ]; then
    echo "エラー: サーバーの起動に失敗しました。"
    read -p "Enterキーを押して終了します..."
    # 元のディレクトリに戻る
    cd - > /dev/null
    exit 1
fi

# 元のディレクトリに戻る
cd - > /dev/null

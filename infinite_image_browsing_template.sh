#!/bin/bash
# このスクリプトは、Infinite Image Browsingを起動します。

# --- 設定項目 ---
# Stable Diffusion WebUI (reForge) のルートディレクトリからの相対パス
# 必要に応じて環境に合わせて変更してください。
SD_WEBUI_PATH="../stable-diffusion-webui-reForge"
# --- 設定項目ここまで ---

# スクリプトのディレクトリを取得
SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"

# 各パスを設定
EASY_TOOLS_DIR="$SCRIPT_DIR"
IIB_DIR="$EASY_TOOLS_DIR/InfiniteImageBrowsing/sd-webui-infinite-image-browsing"
SD_CFG_PATH="$EASY_TOOLS_DIR/$SD_WEBUI_PATH/config.json"

# Infinite Image Browsingがセットアップされているか確認
if [ ! -d "$IIB_DIR/venv/" ]; then
    echo "Infinite Image Browsingが見つかりません。セットアップを実行します..."
    bash "$EASY_TOOLS_DIR/InfiniteImageBrowsing/InfiniteImageBrowsing_Update.sh"
fi

# 再度確認し、それでも存在しない場合はエラー終了
if [ ! -d "$IIB_DIR/venv/" ]; then
    echo "エラー: Infinite Image Browsingのセットアップに失敗しました。"
    echo "$IIB_DIR/venv/ が見つかりません。"
    read -p "Enterキーを押して終了します..."
    exit 1
fi

# Infinite Image Browsingのディレクトリに移動
cd "$IIB_DIR"

# Python仮想環境を有効化
source "$EASY_TOOLS_DIR/Python/python_activate.sh"
if [ $? -ne 0 ]; then
    echo "エラー: Python仮想環境の有効化に失敗しました。"
    read -p "Enterキーを押して終了します..."
    cd - > /dev/null
    exit 1
fi

# ブラウザで開く (xdg-openがなければURLを表示)
URL="http://localhost:7850"
echo "Infinite Image Browsingを起動しています。"
echo "次のURLにアクセスしてください: $URL"
if command -v xdg-open &> /dev/null;
then
    xdg-open "$URL"
fi

# サーバーを起動
echo "コマンド: python app.py --sd_webui_config=\"$SD_CFG_PATH\" --sd_webui_path_relative_to_config --host=localhost --port=7850 $@"
python app.py --sd_webui_config="$SD_CFG_PATH" --sd_webui_path_relative_to_config --host=localhost --port=7850 "$@"

# エラーチェック
if [ $? -ne 0 ]; then
    echo "エラー: サーバーの起動に失敗しました。"
    read -p "Enterキーを押して終了します..."
fi

# 元のディレクトリに戻る
cd - > /dev/null

#!/bin/bash
# FFmpegのセットアップ（aptを使用してインストール）

# スクリプトがあるディレクトリに移動
cd "$(dirname "$0")" || exit 1

echo "FFmpegのセットアップを開始します。"

# パッケージリストの更新
echo "Updating package list..."
sudo apt update
if [ $? -ne 0 ]; then
    echo "Error: Failed to update package list. Please check your internet connection or apt configuration."
    exit 1
fi

# FFmpegのインストール
echo "Installing FFmpeg..."
sudo apt install -y ffmpeg
if [ $? -ne 0 ]; then
    echo "Error: Failed to install FFmpeg. Please check your apt configuration or try again later."
    exit 1
fi

echo "FFmpeg has been successfully installed."

# インストールされたFFmpegのバージョンを表示して確認
ffmpeg -version

exit 0

#!/bin/bash
# FFmpegを使用して動画を再エンコードし、ファイルサイズを最適化するスクリプト

# スクリプトがあるディレクトリに移動
cd "$(dirname "$0")" || exit 1

# FFmpegがインストールされているか確認
if ! command -v ffmpeg &> /dev/null;
then
    echo "Error: FFmpeg is not installed. Please run ffmpeg_setup.sh first."
    exit 1
fi

# デフォルトのCRF値
FFMPEG_CRF=25

# 入力ファイルの取得
INPUT_FILE="$1"
if [ -z "$INPUT_FILE" ]; then
    echo "動画ファイルをドラッグ＆ドロップしてください。"
    read -p "動画ファイル: " INPUT_FILE
fi

# 入力ファイルの存在確認
if [ ! -f "$INPUT_FILE" ]; then
    echo "Error: 動画ファイルが存在しません: $INPUT_FILE"
    exit 1
fi

# 出力ファイル名の生成
FILENAME=$(basename -- "$INPUT_FILE")
EXTENSION="${FILENAME##*.}"
FILENAME_NO_EXT="${FILENAME%.*}"
DIRNAME=$(dirname -- "$INPUT_FILE")

OUTPUT_FILE="${DIRNAME}/${FILENAME_NO_EXT}-crf${FFMPEG_CRF}.${EXTENSION}"

echo ""
echo "FFmpegコマンドを実行します:"
echo "ffmpeg -y -i \"$INPUT_FILE\" -c:v libx264 -crf $FFMPEG_CRF \"$OUTPUT_FILE\""
echo ""

# FFmpegコマンドの実行
ffmpeg -y -i "$INPUT_FILE" -c:v libx264 -crf "$FFMPEG_CRF" "$OUTPUT_FILE"

if [ $? -ne 0 ]; then
    echo "Error: 動画の再エンコードに失敗しました。"
    exit 1
fi

echo "動画の再エンコードが完了しました: $OUTPUT_FILE"
exit 0

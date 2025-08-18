#!/bin/bash
# FFmpegを使用して動画を切り出すスクリプト

# スクリプトがあるディレクトリに移動
cd "$(dirname "$0")" || exit 1

# FFmpegがインストールされているか確認
if ! command -v ffmpeg &> /dev/null;
then
    echo "Error: FFmpeg is not installed. Please run ffmpeg_setup.sh first."
    exit 1
fi

# デフォルトのFFmpeg設定
FFMPEG_CRF=19
FFMPEG_BAUDIO="192k"

# mm:ss 形式を秒数に変換する関数 (ffmpeg_cut.sh から再利用)
convert_to_seconds() {
    local time_str="$1"
    if [[ "$time_str" =~ ^[0-9]+$ ]]; then
        # 秒数形式の場合
        echo "$time_str"
    elif [[ "$time_str" =~ ^([0-9]+):([0-9]{2})$ ]]; then
        # mm:ss 形式の場合
        local minutes="${BASH_REMATCH[1]}"
        local seconds="${BASH_REMATCH[2]}"
        echo "$((minutes * 60 + seconds))"
    else
        echo "-1"
    fi
}

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

# 開始位置の取得
START_TIME_RAW=""
while true; do
    read -p "動画の切り取り開始位置を、秒数か mm:ss 形式で指定してください: " START_TIME_RAW
    START_TIME=$(convert_to_seconds "$START_TIME_RAW")
    if [ "$START_TIME" -ge 0 ]; then
        break
    else
        echo "無効な開始位置形式です。秒数か mm:ss 形式で入力してください。"
    fi
done

# 長さの取得
DURATION_RAW=""
while true; do
    read -p "切り取る動画の長さを、秒数か mm:ss 形式で指定してください: " DURATION_RAW
    DURATION=$(convert_to_seconds "$DURATION_RAW")
    if [ "$DURATION" -ge 0 ]; then
        break
    else
        echo "無効な長さ形式です。秒数か mm:ss 形式で入力してください。"
    fi
done

# 出力ファイル名の生成
FILENAME=$(basename -- "$INPUT_FILE")
EXTENSION="${FILENAME##*.}"
FILENAME_NO_EXT="${FILENAME%.*}"
DIRNAME=$(dirname -- "$INPUT_FILE")

START_TIME_PATH=$(echo "$START_TIME_RAW" | tr ':' '_')
DURATION_PATH=$(echo "$DURATION_RAW" | tr ':' '_')

OUTPUT_FILE="${DIRNAME}/${FILENAME_NO_EXT}-${START_TIME_PATH}-${DURATION_PATH}.${EXTENSION}"

echo ""
echo "FFmpegコマンドを実行します:"
echo "ffmpeg -y -i \"$INPUT_FILE\" -ss $START_TIME -t $DURATION -c:v libx264 -crf $FFMPEG_CRF -c:a aac -b:a $FFMPEG_BAUDIO \"$OUTPUT_FILE\""
echo ""

# FFmpegコマンドの実行
ffmpeg -y -i "$INPUT_FILE" -ss "$START_TIME" -t "$DURATION" -c:v libx264 -crf "$FFMPEG_CRF" -c:a aac -b:a "$FFMPEG_BAUDIO" "$OUTPUT_FILE"

if [ $? -ne 0 ]; then
    echo "Error: 動画の切り取りに失敗しました。"
    exit 1
fi

echo "動画の切り取りが完了しました: $OUTPUT_FILE"
exit 0

#!/bin/bash
# FFmpegを使用して動画から指定フレーム数でWebPアニメーションと音声を切り出すスクリプト

# スクリプトがあるディレクトリに移動
cd "$(dirname "$0")" || exit 1

# FFmpegがインストールされているか確認
if ! command -v ffmpeg &> /dev/null;
then
    echo "Error: FFmpeg is not installed. Please run ffmpeg_setup.sh first."
    exit 1
fi

# mm:ss 形式を秒数に変換する関数 (ffmpeg_cut.sh から再利用)
convert_to_seconds() {
    local time_str="$1"
    if [[ "$time_str" =~ ^[0-9]+$ ]]; then
        echo "$time_str"
    elif [[ "$time_str" =~ ^([0-9]+):([0-9]{2})$ ]]; then
        local minutes="${BASH_REMATCH[1]}"
        local seconds="${BASH_REMATCH[2]}"
        echo "$((minutes * 60 + seconds))"
    else
        echo "-1"
    fi
}

# 引数の取得
FILTER="$1"
FRAMES="$2"
AUDIO_DURATION_RAW="$3"
INPUT_FILE="$4"

# 引数チェック
if [ -z "$FILTER" ] || [ -z "$FRAMES" ] || [ -z "$AUDIO_DURATION_RAW" ]; then
    echo "Usage: $0 <video_filter> <frames> <audio_duration_seconds_or_mmss> [input_file]"
    echo "  Example: $0 \"fps=16\" 81 5.0625 video.mp4"
    exit 1
fi

# 音 مشの長さを秒数に変換
AUDIO_DURATION=$(convert_to_seconds "$AUDIO_DURATION_RAW")
if [ "$AUDIO_DURATION" -eq -1 ]; then
    echo "Error: Invalid audio duration format. Please use seconds or mm:ss."
    exit 1
fi

# 入力ファイルの取得
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

# 出力ファイル名の生成
FILENAME=$(basename -- "$INPUT_FILE")
FILENAME_NO_EXT="${FILENAME%.*}"
DIRNAME=$(dirname -- "$INPUT_FILE")

START_TIME_PATH=$(echo "$START_TIME_RAW" | tr ':' '_')

OUTPUT_WEBP_FILE="${DIRNAME}/${FILENAME_NO_EXT}-${START_TIME_PATH}.webp"
OUTPUT_WAV_FILE="${DIRNAME}/${FILENAME_NO_EXT}-${START_TIME_PATH}.wav"

# WebPアニメーションの抽出
echo ""
echo "WebPアニメーションを抽出します:"
echo "ffmpeg -y -i \"$INPUT_FILE\" -vf \"$FILTER\" -ss $START_TIME -frames:v $FRAMES -vcodec libwebp -lossless 1 -loop 0 -an \"$OUTPUT_WEBP_FILE\""
echo ""
ffmpeg -y -i "$INPUT_FILE" -vf "$FILTER" -ss "$START_TIME" -frames:v "$FRAMES" -vcodec libwebp -lossless 1 -loop 0 -an "$OUTPUT_WEBP_FILE"

if [ $? -ne 0 ]; then
    echo "Error: WebPアニメーションの抽出に失敗しました。"
    exit 1
fi

echo "WebPアニメーションの抽出が完了しました: $OUTPUT_WEBP_FILE"

# 音声トラックの有無を判定
if ffprobe -v error -select_streams a -show_entries stream=codec_type -of default=noprint_wrappers=1:nokey=1 "$INPUT_FILE" | grep -q audio; then
    # 音声の切り出し
    echo ""
    echo "音声を切り出します:"
    echo "ffmpeg -y -i \"$INPUT_FILE\" -ss $START_TIME -t $AUDIO_DURATION -vn -acodec pcm_s16le \"$OUTPUT_WAV_FILE\""
    echo ""
    ffmpeg -y -i "$INPUT_FILE" -ss "$START_TIME" -t "$AUDIO_DURATION" -vn -acodec pcm_s16le "$OUTPUT_WAV_FILE"

    if [ $? -ne 0 ]; then
        echo "Error: 音声の切り出しに失敗しました。"
        exit 1
    fi
    echo "音声の切り出しが完了しました: $OUTPUT_WAV_FILE"
else
    echo "音声トラックが見つかりませんでした。音声の切り出しはスキップします。"
fi

exit 0

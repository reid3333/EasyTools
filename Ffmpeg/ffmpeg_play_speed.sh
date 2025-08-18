#!/bin/bash
# FFmpegを使用して動画の再生速度を変更するスクリプト

# スクリプトがあるディレクトリに移動
cd "$(dirname "$0")" || exit 1

# FFmpegがインストールされているか確認
if ! command -v ffmpeg &> /dev/null; then
    echo "Error: FFmpeg is not installed. Please run ffmpeg_setup.sh first."
    exit 1
fi

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

# 再生スピードの取得とバリデーション
PLAY_SPEED=""
while true; do
    read -p "動画の再生スピードを 0.5～2.0 の範囲で指定してください: " PLAY_SPEED
    # 小数点を含む数値のバリデーション
    if [[ "$PLAY_SPEED" =~ ^[0-9]+(\.[0-9]+)?$ ]]; then
        # 範囲チェック (bashでは浮動小数点数の比較が直接できないためbcを使用)
        if (( $(echo "$PLAY_SPEED >= 0.5" | bc -l) )) && (( $(echo "$PLAY_SPEED <= 2.0" | bc -l) )); then
            break
        else
            echo "無効な再生スピードです。0.5～2.0の範囲で入力してください。"
        fi
    else
        echo "無効な形式です。数値を入力してください。"
    fi
done

# 出力ファイル名の生成
FILENAME=$(basename -- "$INPUT_FILE")
EXTENSION="${FILENAME##*.}"
FILENAME_NO_EXT="${FILENAME%.*}"
DIRNAME=$(dirname -- "$INPUT_FILE")

OUTPUT_FILE="${DIRNAME}/${FILENAME_NO_EXT}-x${PLAY_SPEED}.${EXTENSION}"

echo ""
echo "FFmpegコマンドを実行します:"
echo "ffmpeg -y -i \"$INPUT_FILE\" -af \"atempo=${PLAY_SPEED}\" -bsf:v setts=ts=TS/${PLAY_SPEED} -c:v copy \"$OUTPUT_FILE\""
echo ""

# FFmpegコマンドの実行
# atempoフィルタは0.5から2.0の範囲でしか使えないため、それ以外の速度は複数回適用する必要があるが、
# このスクリプトでは元のバッチファイルに合わせて単一のatempoフィルタを使用
ffmpeg -y -i "$INPUT_FILE" -af "atempo=${PLAY_SPEED}" -bsf:v setts=ts=TS/"${PLAY_SPEED}" -c:v copy "$OUTPUT_FILE"

if [ $? -ne 0 ]; then
    echo "Error: 動画の再生スピードの設定に失敗しました。"
    exit 1
fi

echo "動画の再生スピードが変更されました: $OUTPUT_FILE"
exit 0

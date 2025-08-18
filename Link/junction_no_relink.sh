#!/bin/bash
# シンボリックリンクを作成するスクリプト（既存のリンクは上書きしない）

# 引数の数をチェック
if [ "$#" -ne 2 ]; then
    echo "Usage: $0 <link_destination> <link_source>"
    echo "  link_destination: リンクを作成するパス"
    echo "  link_source:      リンクの参照元となるパス"
    exit 1
fi

LINK_DST="$1"
LINK_SRC="$2"

# リンク先が既にシンボリックリンクの場合は何もしない
if [ -L "$LINK_DST" ]; then
    echo "Symbolic link already exists at '$LINK_DST'. No action taken."
    exit 0
fi

# リンク先がシンボリックリンクでないファイルやディレクトリの場合、エラー終了
if [ -e "$LINK_DST" ]; then
    echo "Error: A file or directory already exists at '$LINK_DST'."
    echo "Please remove it before creating a link."
    exit 1
fi

# リンク元の存在確認
if [ ! -e "$LINK_SRC" ]; then
    echo "Error: Link source '$LINK_SRC' does not exist."
    exit 1
fi

# シンボリックリンクを作成
# -s: シンボリックリンク
# -T: リンク先がディレクトリの場合、その中に作成せず、リンク先自体をリンクにする
echo "Creating symbolic link: $LINK_DST -> $LINK_SRC"
ln -sT "$LINK_SRC" "$LINK_DST"

if [ $? -ne 0 ]; then
    echo "Error: Failed to create symbolic link."
    exit 1
fi

echo "Symbolic link created successfully."
exit 0

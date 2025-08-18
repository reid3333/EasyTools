#!/bin/bash
# シンボリックリンクを作成するスクリプト (ln -s のラッパー)

# 引数の数をチェック
if [ "$#" -ne 2 ]; then
    echo "Usage: $0 <link_destination> <link_source>"
    echo "  link_destination: リンクを作成するパス"
    echo "  link_source:      リンクの参照元となるパス"
    exit 1
fi

LINK_DST="$1"
LINK_SRC="$2"

# リンク元の存在確認
if [ ! -e "$LINK_SRC" ]; then
    echo "Error: Link source '$LINK_SRC' does not exist."
    exit 1
fi

# シンボリックリンクを作成
# -s: シンボリックリンク
# -f: リンク先が既に存在する場合、上書きする
# -T: リンク先がディレクトリの場合、その中に作成せず、リンク先自体をリンクにする
echo "Creating symbolic link: $LINK_DST -> $LINK_SRC"
ln -sfT "$LINK_SRC" "$LINK_DST"

if [ $? -ne 0 ]; then
    echo "Error: Failed to create symbolic link."
    exit 1
fi

echo "Symbolic link created successfully."
exit 0

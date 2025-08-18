#!/bin/bash

# gitコマンドの存在確認
if ! command -v git &> /dev/null; then
    echo "[ERROR] gitが見つかりません。gitをインストールしてください。"
    echo "例: sudo apt update && sudo apt install git"
    exit 1
fi

exit 0

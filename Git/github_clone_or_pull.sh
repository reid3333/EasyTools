#!/bin/bash

# GitHubリポジトリをクローンまたはプルします。
# 引数:
# $1: GitHubユーザー名
# $2: GitHubリポジトリ名
# $3: ブランチ名 (オプション)
# $4: コミットハッシュ (オプション)

set -e

# --- 引数のチェック ---
if [ -z "$1" ] || [ -z "$2" ]; then
    echo "[ERROR] 使用法: $0 <github_user> <github_repo> [branch] [commit_hash]"
    exit 1
fi

# --- 変数設定 ---
GITHUB_USER=$1
GITHUB_REPO=$2
BRANCH_NAME=$3
COMMIT_HASH=$4

GIT_URL="https://github.com/${GITHUB_USER}/${GITHUB_REPO}"
REPO_DIR="$GITHUB_REPO"

# --- gitコマンドの存在確認 ---
if ! command -v git &> /dev/null; then
    echo "[ERROR] gitが見つかりません。gitをインストールしてください。"
    exit 1
fi

# --- クローンまたはプル ---
echo "リポジトリを処理中: ${GIT_URL}"

if [ -d "$REPO_DIR" ]; then
    echo "ディレクトリ '$REPO_DIR' は既に存在します。"
    cd "$REPO_DIR"

    REMOTE_URL=$(git config --get remote.origin.url)
    if [ "$REMOTE_URL" == "$GIT_URL" ]; then
        echo "リモートURLが一致しました。プルを実行します。"
        if [ -n "$BRANCH_NAME" ]; then
            echo "ブランチを '$BRANCH_NAME' に切り替えます..."
            git switch -f "$BRANCH_NAME" --quiet
        fi
        git pull
    else
        echo "[WARNING] リモートURLが一致しません。既存のディレクトリを削除して再クローンします。"
        echo "  既存のリモート: $REMOTE_URL"
        echo "  要求されたリモート: $GIT_URL"
        cd ..
        rm -rf "$REPO_DIR"
        git clone "$GIT_URL"
        if [ -n "$BRANCH_NAME" ]; then
            cd "$REPO_DIR"
            git switch -f "$BRANCH_NAME" --quiet
        fi
    fi
else
    echo "ディレクトリ '$REPO_DIR' が見つかりません。クローンを実行します。"
    git clone "$GIT_URL"
    if [ -n "$BRANCH_NAME" ]; then
        cd "$REPO_DIR"
        git switch -f "$BRANCH_NAME" --quiet
    fi
fi

# --- コミットハッシュのチェックアウト ---
if [ -n "$COMMIT_HASH" ]; then
    echo "コミットハッシュ '$COMMIT_HASH' をチェックアウトします..."
    # ハッシュの先頭7文字をブランチ名にする
    SHORT_HASH=${COMMIT_HASH:0:7}
    git switch -C "$SHORT_HASH" "$COMMIT_HASH"
fi

echo "処理が完了しました。"

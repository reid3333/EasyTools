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

"$(dirname "$0")/git_clone_or_pull.sh" "$GIT_URL" "$BRANCH_NAME"

# --- コミットハッシュのチェックアウト ---
if [ -n "$COMMIT_HASH" ]; then
    echo "コミットハッシュ '$COMMIT_HASH' をチェックアウトします..."
    # ハッシュの先頭7文字をブランチ名にする
    SHORT_HASH=${COMMIT_HASH:0:7}
    git -C "$GITHUB_REPO" switch -C "$SHORT_HASH" "$COMMIT_HASH"
fi

echo "処理が完了しました。"
#!/bin/bash

# GitHubリポジトリをクローンまたはプルし、指定されたタグをチェックアウトします。
# 引数:
# $1: GitHubユーザー名
# $2: GitHubリポジトリ名
# $3: ブランチ名
# $4: タグ

set -e

# --- 引数のチェック ---
if [ -z "$1" ] || [ -z "$2" ]; then
    echo "[ERROR] 使用法: $0 <github_user> <github_repo> [branch] [tag]"
    exit 1
fi

# --- 変数設定 ---
GITHUB_USER=$1
GITHUB_REPO=$2
BRANCH_NAME=$3
GITHUB_TAG=$4

GIT_URL="https://github.com/${GITHUB_USER}/${GITHUB_REPO}"

"$(dirname "$0")/git_clone_or_pull.sh" "$GIT_URL" "$BRANCH_NAME"

# --- タグのチェックアウト ---
if [ -n "$GITHUB_TAG" ]; then
    echo "タグ '$GITHUB_TAG' をチェックアウトします..."
    git -C "$GITHUB_REPO" switch -C "$GITHUB_TAG" "tags/$GITHUB_TAG"
fi

echo "処理が完了しました。"

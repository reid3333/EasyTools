#!/bin/bash
set -e

# GitHub リポジトリをクローン/プルし、任意でコミットハッシュをチェックアウトするラッパー
# 使い方: bash github_clone_or_pull_hash.sh <github_user> <github_repo> [branch] [commit_hash]

if [ -z "$1" ] || [ -z "$2" ]; then
  echo "[ERROR] 使用法: $0 <github_user> <github_repo> [branch] [commit_hash]"
  exit 1
fi

GITHUB_USER="$1"
GITHUB_REPO="$2"
BRANCH_NAME="$3"
COMMIT_HASH="$4"

SCRIPT_DIR=$(cd "$(dirname "$0")" && pwd)

"$SCRIPT_DIR/github_clone_or_pull.sh" "$GITHUB_USER" "$GITHUB_REPO" "$BRANCH_NAME"

if [ -n "$COMMIT_HASH" ]; then
  SHORT_HASH="${COMMIT_HASH:0:7}"
  echo "[INFO] コミットをチェックアウト: $COMMIT_HASH (ブランチ: $SHORT_HASH)"
  (
    cd "$GITHUB_REPO"
    git fetch --all
    git switch -C "$SHORT_HASH" "$COMMIT_HASH"
  )
fi

echo "[INFO] 完了: ${GITHUB_USER}/${GITHUB_REPO}"


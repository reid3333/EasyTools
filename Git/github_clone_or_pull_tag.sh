#!/bin/bash
set -e

# GitHub リポジトリをクローン/プルし、任意でタグをチェックアウトするラッパー
# 使い方: bash github_clone_or_pull_tag.sh <github_user> <github_repo> [branch] [tag]

if [ -z "$1" ] || [ -z "$2" ]; then
  echo "[ERROR] 使用法: $0 <github_user> <github_repo> [branch] [tag]"
  exit 1
fi

GITHUB_USER="$1"
GITHUB_REPO="$2"
BRANCH_NAME="$3"
TAG_NAME="$4"

SCRIPT_DIR="$(dirname -- "$(realpath -- "${BASH_SOURCE[0]}")")"

"$SCRIPT_DIR/github_clone_or_pull.sh" "$GITHUB_USER" "$GITHUB_REPO" "$BRANCH_NAME"

if [ -n "$TAG_NAME" ]; then
  echo "[INFO] タグをチェックアウト: $TAG_NAME"
  (
    cd "$GITHUB_REPO"
    git fetch --tags
    git switch -C "$TAG_NAME" "tags/$TAG_NAME"
  )
fi

echo "[INFO] 完了: ${GITHUB_USER}/${GITHUB_REPO}"


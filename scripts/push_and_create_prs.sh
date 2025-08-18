#!/bin/bash
set -euo pipefail

# 目的:
#  - 全ての作業ブランチを push し、GitHub CLI(gh) が利用可能な場合は PR を作成する
# 前提:
#  - リモート "origin" が正しく設定済み
#  - GitHub CLI(gh) が認証済み (gh auth login)
#  - PR本文は PR_DRAFTS/*.md に格納済み

ROOT_DIR=$(cd "$(dirname "$0")/.." && pwd)
cd "$ROOT_DIR"

BRANCHES=( \
  feat/git-wrappers \
  feat/hf-download \
  feat/civitai-download \
  feat/comfyui-update \
  feat/app-updaters-1 \
  feat/app-updaters-2 \
  docs/migration-log \
)

BASE_BRANCH=${BASE_BRANCH:-main}

REMOTE_URL=$(git remote get-url origin)
echo "[origin] $REMOTE_URL"

# owner/repo の抽出（https, ssh どちらも対応）
OWNER_REPO=$(echo "$REMOTE_URL" | sed -E 's#(git@github.com:|https://github.com/)##; s/.git$//' )
OWNER=${OWNER_REPO%%/*}
REPO=${OWNER_REPO##*/}

echo "[repo] $OWNER/$REPO (base=$BASE_BRANCH)"

HAVE_GH=0
if command -v gh >/dev/null 2>&1; then
  HAVE_GH=1
  gh --version | head -n1
else
  echo "[WARN] gh コマンドが見つかりません。PR作成はスキップし、URLを出力します。"
fi

push_status_file=PR_DRAFTS/push_status.txt
pr_links_file=PR_DRAFTS/pr_links.txt
: > "$push_status_file"
: > "$pr_links_file"

CURRENT_BRANCH=$(git rev-parse --abbrev-ref HEAD)

for b in "${BRANCHES[@]}"; do
  echo "\n[PUSH] $b" | tee -a "$push_status_file"
  if git rev-parse --verify "$b" >/dev/null 2>&1; then
    git switch "$b" >/dev/null
    if git push -u origin "$b"; then
      echo "OK" | tee -a "$push_status_file"
    else
      echo "NG" | tee -a "$push_status_file"
      continue
    fi

    # PR 作成
    TITLE="$b"
    BODY_FILE="PR_DRAFTS/$(echo "$b" | tr '/' '-')".md
    if [ -f "$BODY_FILE" ]; then
      TITLE_LINE=$(head -n1 "$BODY_FILE" | sed 's/^# *//')
      if [ -n "$TITLE_LINE" ]; then TITLE="$TITLE_LINE"; fi
    fi

    if [ "$HAVE_GH" -eq 1 ]; then
      echo "[PR] $b -> $BASE_BRANCH : $TITLE"
      gh pr create -B "$BASE_BRANCH" -H "$b" -t "$TITLE" -F "$BODY_FILE" || {
        echo "[WARN] gh pr create 失敗: $b" | tee -a "$pr_links_file" ;
      }
    else
      URL="https://github.com/${OWNER}/${REPO}/compare/${BASE_BRANCH}...${b}?expand=1"
      echo "$b => $URL" | tee -a "$pr_links_file"
    fi
  else
    echo "NG (branch not found)" | tee -a "$push_status_file"
  fi
done

git switch "$CURRENT_BRANCH" >/dev/null

echo "\n[Summary: push]"
cat "$push_status_file" || true

if [ -s "$pr_links_file" ]; then
  echo "\n[PR Links] (gh未インストール時の作成URL)"
  cat "$pr_links_file"
fi

echo "\n完了。"


#!/bin/bash

# GitHubリポジトリをクローンまたはプルし、指定されたハッシュをチェックアウトします。
# 引数:
# $1: GitHubユーザー名
# $2: GitHubリポジトリ名
# $3: ブランチ名
# $4: コミットハッシュ

set -e

"$(dirname "$0")/github_clone_or_pull.sh" "$1" "$2" "$3" "$4"

#!/bin/bash

set -e

source "$(dirname "$0")/git_set_path.sh"

GIT_CLONE_OR_PULL_URL=$1
BRANCH_NAME=$2

echo
echo "$GIT_CLONE_OR_PULL_URL"

GIT_CLONE_OR_PULL_DIR=$(basename "$GIT_CLONE_OR_PULL_URL")

if [ -d "$GIT_CLONE_OR_PULL_DIR" ]; then
    REMOTE_ORIGIN_URL=$(git -C "$GIT_CLONE_OR_PULL_DIR" config --get remote.origin.url)

    if [ "$GIT_CLONE_OR_PULL_URL" == "$REMOTE_ORIGIN_URL" ]; then
        if [ -n "$BRANCH_NAME" ]; then
            echo "git -C $GIT_CLONE_OR_PULL_DIR switch -f $BRANCH_NAME --quiet"
            git -C "$GIT_CLONE_OR_PULL_DIR" switch -f "$BRANCH_NAME" --quiet
        fi

        echo "git -C $GIT_CLONE_OR_PULL_DIR pull"
        git -C "$GIT_CLONE_OR_PULL_DIR" pull
        exit 0
    else
        echo "rm -rf $GIT_CLONE_OR_PULL_DIR"
        rm -rf "$GIT_CLONE_OR_PULL_DIR"
    fi
fi

echo "git clone $GIT_CLONE_OR_PULL_URL"
git clone "$GIT_CLONE_OR_PULL_URL"

if [ -n "$BRANCH_NAME" ]; then
    echo "git -C $GIT_CLONE_OR_PULL_DIR switch -f $BRANCH_NAME --quiet"
    git -C "$GIT_CLONE_OR_PULL_DIR" switch -f "$BRANCH_NAME" --quiet
fi

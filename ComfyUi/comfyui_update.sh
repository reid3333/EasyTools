#!/bin/bash

# ComfyUIのインストールまたはアップデートを行います。

set -e

# --- スクリプトパス設定 ---
SCRIPT_DIR=$(cd "$(dirname "$0")" && pwd)
EASY_TOOLS_DIR=$(cd "$SCRIPT_DIR/.." && pwd)

GITHUB_CLONE_OR_PULL_SH="$EASY_TOOLS_DIR/Git/github_clone_or_pull.sh"
PYTHON_ACTIVATE_SH="$EASY_TOOLS_DIR/Python/python_activate.sh"

# --- ComfyUIのクローンまたはプル ---
COMFYUI_VERSION=""
if [ -f "$SCRIPT_DIR/ComfyUi_Version.txt" ]; then
    COMFYUI_VERSION=$(cat "$SCRIPT_DIR/ComfyUi_Version.txt")
fi

bash "$GITHUB_CLONE_OR_PULL_SH" "comfyanonymous" "ComfyUI" "master" "$COMFYUI_VERSION"

# --- Python環境のセットアップと依存パッケージのインストール ---
cd "$EASY_TOOLS_DIR/ComfyUi/ComfyUI"

echo "Python仮想環境をセットアップします..."
source "$PYTHON_ACTIVATE_SH"

echo "pip, setuptools, wheelをアップグレードします..."
pip install -qq -U pip setuptools wheel

# Linux向けのTorchバージョンを設定
TORCH_VERSION_FILE="$SCRIPT_DIR/Torch_Version_linux.txt"
if [ ! -f "$TORCH_VERSION_FILE" ]; then
    # CPU版のPyTorchをデフォルトとしてファイルを作成
    echo "torch torchvision torchaudio --index-url https://download.pytorch.org/whl/cpu" > "$TORCH_VERSION_FILE"
fi
TORCH_VERSION=$(cat "$TORCH_VERSION_FILE")

echo "PyTorchをインストールします... ($TORCH_VERSION)"
pip install -qq $TORCH_VERSION

# TODO: TritonとSageAttentionはWindows固有か、または特定のビルドが必要なため、
# Linux版では一旦インストールをスキップします。必要に応じて手動でインストールしてください。

echo "requirements.txtから依存関係をインストールします..."
pip install -qq -r requirements.txt

# --- ComfyUI-Managerのクローンまたはプル ---
cd "custom_nodes"

COMFYUI_MANAGER_VERSION=""
if [ -f "$SCRIPT_DIR/ComfyUiManager_Version.txt" ]; then
    COMFYUI_MANAGER_VERSION=$(cat "$SCRIPT_DIR/ComfyUiManager_Version.txt")
fi

bash "$GITHUB_CLONE_OR_PULL_SH" "Comfy-Org" "ComfyUI-Manager" "main" "$COMFYUI_MANAGER_VERSION"

cd ../..

echo "ComfyUIのセットアップが完了しました。"

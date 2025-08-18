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
pushd "$EASY_TOOLS_DIR/ComfyUi/ComfyUI" > /dev/null

echo "Python仮想環境をセットアップします..."
source "$PYTHON_ACTIVATE_SH"

echo "pip, setuptools, wheelをアップグレードします..."
pip install -qq -U pip setuptools wheel

# Linux向けのTorchバージョンを設定
TORCH_VERSION_FILE="$SCRIPT_DIR/Torch_Version_linux.txt"
if [ ! -f "$TORCH_VERSION_FILE" ]; then
    # GPUの有無をチェック
    if command -v nvidia-smi &> /dev/null && nvidia-smi | grep "NVIDIA-SMI" &> /dev/null; then
        echo "NVIDIA GPUが検出されました。GPU版のPyTorchを設定します。"
        # CUDA 12.8版のPyTorchをデフォルトとしてファイルを作成 (Windows版に合わせる)
        echo "torch==2.8.0+cu128 torchvision==0.23.0+cu128 torchaudio==2.8.0+cu128 --index-url https://download.pytorch.org/whl/cu128" > "$TORCH_VERSION_FILE"
    else
        echo "NVIDIA GPUが検出されませんでした。CPU版のPyTorchを設定します。"
        # CPU版のPyTorchをデフォルトとしてファイルを作成
        echo "torch torchvision torchaudio --index-url https://download.pytorch.org/whl/cpu" > "$TORCH_VERSION_FILE"
    fi
fi
TORCH_VERSION=$(cat "$TORCH_VERSION_FILE")

echo "PyTorchをインストールします... ($TORCH_VERSION)"
pip install -qq $TORCH_VERSION

# Tritonのインストール (GPU版の場合のみ)
if command -v nvidia-smi &> /dev/null && nvidia-smi | grep "NVIDIA-SMI" &> /dev/null; then
    echo "Tritonをインストールします..."
    pip install -qq triton
    if [ $? -ne 0 ]; then
        echo "[WARNING] Tritonのインストールに失敗しました。手動でインストールする必要があるかもしれません。"
    fi
fi

# SageAttentionのインストール (GPU版の場合のみ)
if command -v nvidia-smi &> /dev/null && nvidia-smi | grep "NVIDIA-SMI" &> /dev/null; then
    echo "SageAttentionをインストールします..."
    # Linux版のSageAttentionのwheelファイルが見つからないため、pip installを試みます。
    # もし失敗する場合は、手動でのビルドやインストールが必要になる可能性があります。
    pip install -qq sageattention
    if [ $? -ne 0 ]; then
        echo "[WARNING] SageAttentionのインストールに失敗しました。手動でインストールする必要があるかもしれません。"
    fi
fi

echo "requirements.txtから依存関係をインストールします..."
pip install -qq -r requirements.txt

# --- ComfyUI-Managerのクローンまたはプル ---
pushd "custom_nodes" > /dev/null

COMFYUI_MANAGER_VERSION=""
if [ -f "$SCRIPT_DIR/ComfyUiManager_Version.txt" ]; then
    COMFYUI_MANAGER_VERSION=$(cat "$SCRIPT_DIR/ComfyUiManager_Version.txt")
fi

bash "$GITHUB_CLONE_OR_PULL_SH" "Comfy-Org" "ComfyUI-Manager" "main" "$COMFYUI_MANAGER_VERSION"

popd > /dev/null # custom_nodes から戻る

popd > /dev/null # ComfyUI ディレクトリから戻る

echo "ComfyUIのセットアップが完了しました。"

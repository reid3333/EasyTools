# EasyTools Linux 移植ログ

このドキュメントは、Windows バッチから Linux (Bash) へ移植したスクリプトの一覧と要点です。

## 追加・移植したスクリプト

- Git
  - `Git/github_clone_or_pull_tag.sh`: タグチェックアウト対応ラッパー
  - `Git/github_clone_or_pull_hash.sh`: ハッシュチェックアウト対応ラッパー

- Download / Hugging Face
  - `Download/hugging_face.sh`: 単一ファイルの取得 (aria/curl 統合)
  - `Download/hugging_face_hub.sh`: huggingface_hub によるスナップショット取得

- Download / Civitai
  - `Civitai/civitai_api_key.sh`: API Key の保存
  - `Civitai/civitai_model_download.sh`: モデルのダウンロード
  - `Civitai/civitai_model_download_unzip.sh`: ZIP 取得＆展開

- ComfyUI
  - `ComfyUi/ComfyUi_Update.sh`: 本体と Manager の取得・依存導入
  - `ComfyUi/ComfyUi_LatestVersion.sh`: 最新リリースタグの取得
  - `ComfyUi/ComfyUiManager_LatestVersion.sh`: 直近タグの取得

- InfiniteImageBrowsing
  - `InfiniteImageBrowsing/InfiniteImageBrowsing_Update.sh`

- GenImageViewer
  - `GenImageViewer/GenImageViewer_Update.sh`

- SdImageDiet
  - `SdImageDiet/SdImageDiet_Update.sh`
  - `SdImageDiet/SdImageDiet_Activate.sh`

- Mosaic
  - `Mosaic/Mosaic_Update.sh`
  - `Mosaic/Mosaic_Activate.sh`

- LamaCleaner
  - `LamaCleaner/LamaCleaner_Update.sh`
  - `LamaCleaner/LamaCleaner_Activate.sh`

## 既存 (参考)

- コア機能 (既に移植済み)
  - `InstallerTemplate.sh`
  - `Git/github_clone_or_pull.sh`
  - `Python/python_activate.sh`
  - `Download/aria.sh`, `aria_use_aria.sh`, `aria_use_curl.sh`

## 使い方の例

- ComfyUI を更新:
  - `bash ComfyUi/ComfyUi_Update.sh`
  - 任意: `bash ComfyUi/ComfyUi_LatestVersion.sh` 実行後に再実行で特定タグへ固定

- Hugging Face からスナップショット取得:
  - `bash Download/hugging_face_hub.sh <local_dir> <repo_id> <repo_type> [<allow_patterns>...]`

- Civitai からモデル ZIP を展開付きで取得:
  - `bash Civitai/civitai_model_download_unzip.sh <dir> <filename> <model_id> <version_id>`

## 注意点 / 未対応

- PyTorch/Triton の最適な組み合わせは環境依存のため、用途に応じて手動導入をお願いします。
- `LlamaCpp_Update.bat` 相当は Linux ではビルド手順が前提となるため未移植です（別タスク推奨）。
- ネットワーク/API アクセスを行うスクリプトは `curl` と `python3` を利用します。必要に応じて `sudo apt install -y curl python3 python3-venv unzip` を実行してください。


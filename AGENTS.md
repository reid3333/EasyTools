# Repository Guidelines

## 言語
- 特に明示しない限り日本語で応答してください。
- 特に明示しない限りコメントやコミットログやPRコメントは日本語で作成してください。

## プロジェクト構成とモジュール
- スクリプトはツール単位でディレクトリ分割：`Git/`（clone/pull）、`Python/`（venv・同梱アーカイブ）、`Download/`（aria2/curl）、`ComfyUi/`、`LamaCleaner/`、`LlamaCpp/`、`Ffmpeg/`、`Mosaic/`、`Civitai/`、`InfiniteImageBrowsing/`、`Bat/`（共通バッチ）、`Link/`（ジャンクション）。
- 生成物/キャッシュ：`Python/*.zip`、`*/env`、`Python/venv` などは `.gitignore` 済み。
- Linux への移植方針は `GEMINI.md`。`.bat` と同階層に `.sh` を配置（例：`Git/github_clone_or_pull.sh`）。

## ビルド・テスト・ローカル実行
- ビルド不要。スクリプトを直接実行します。
- Windows 例：
  - `Git/GitHub_CloneOrPull.bat` — リポジトリの clone/pull。
  - `LamaCleaner/LamaCleaner_Update.bat` — Lama Cleaner の導入/更新。
  - `Ffmpeg/Ffmpeg_Save.bat` — メディアの保存/変換。
- Linux 例：
  - `source Python/python_activate.sh venv` — venv 作成/有効化。
  - `bash Git/github_clone_or_pull.sh <user> <repo> [branch] [hash]` — clone/pull（任意で特定ハッシュをチェックアウト）。

## コーディング規約・命名
- BAT：PascalCase（`VerbNoun`）、CRLF、`%~dp0` によるリポジトリ相対パス、処理単位で明瞭なラベル。
- Shell：`lowercase_with_underscores.sh`、先頭に `#!/bin/bash`、`set -e`、変数を必ずクォート、依存チェックを先頭に、冪等性を担保。`chmod +x` を付与。
- Python：既定はシステム `python3`。仮想環境は `Python/venv` を推奨。

## テスト方針
- 公式テスト基盤は未整備。PR では以下を簡潔に提示：
  - Git：空ディレクトリで実行→再実行で差分なし（冪等）。
  - Python：venv 作成→有効化→`pip install -U pip` 成功を確認。
  - FFmpeg：小さなサンプルに対し出力ファイルの生成を確認。
- 可能なら `--help` やドライラン、期待されるログを添付。

## コミット・PR ガイドライン
- コミットは Conventional Commits 推奨（`feat:`、`fix:`、`docs:` 等）。小さな論理単位で、命令形で記述。
- PR には目的/背景、影響範囲（変更ディレクトリ）、実行例（コマンド）、検証環境（Ubuntu 24.04）、関連 Issue、ログ/スクリーンショットを添付。

## セキュリティと設定
- 秘密情報や大きなバイナリはコミットしない。API キーは `Civitai/CivitaiApiKey.txt` に保存。`env/`、`venv/`、`Download/` は `.gitignore` により除外。
- 絶対パスを避け、リポジトリ相対パスを使用。生成物は `Download/` などの一時領域へ配置。

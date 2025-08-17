# EasyTools プロジェクト (Linux移植版)

## プロジェクト概要

このプロジェクトの目的は、既存のWindows用バッチスクリプト群「EasyTools」を、**Linux (Ubuntu 24.04 LTS) 環境で動作するようにシェルスクリプトへ移植する**ことです。

オリジナルのEasyToolsは、AI関連ツールや開発ツール（ComfyUI, Lama Cleaner等）のセットアップ、アップデート、モデルダウンロードなどを自動化するWindowsバッチファイル群です。本プロジェクトでは、これらの機能をLinuxユーザーが利用できるように、同等の機能をシェルスクリプトで実現します。

## 移植の基本方針

- **スクリプト言語:** Windowsバッチファイル (`.bat`) をBashシェルスクリプト (`.sh`) に置き換えます。
- **互換性:** Ubuntu 24.04 LTSでの動作を第一目標とします。
- **依存関係の管理:** Windowsのポータブル環境構築（Portable Git/Python）の思想は引き継ぎつつ、Linuxの標準的なパッケージ管理（`apt`）や仮想環境（`venv`）の利用を基本とします。
- **コマンドの置換:** Windows固有のコマンド (`chcp`, `where`, `reg`, `PowerShell`) は、Linuxの同等コマンド (`export LANG`, `which`, `command -v`, `sed`, `awk`, `grep`など) に置き換えます。
- **パスの解決:** Windows形式のパス (`%~dp0`, `%USERPROFILE%`) は、Linux形式 (`$(dirname "$0")`, `$HOME`) に変換します。

## 主な機能（移植対象）

- **環境構築:**
    - `apt`を利用したGit, Python等のインストール。
    - Pythonの仮想環境 (`venv`) の構築と有効化。
- **リポジトリ管理:**
    - 指定したGitHubリポジトリのクローンまたはプル。
- **ダウンローダー:**
    - `curl`や`aria2c`を使用したファイルダウンロード（Hugging Faceからのモデルダウンロードを含む）。
- **アプリケーション管理:**
    - ComfyUI, Lama Cleaner等のインストール、アップデート、および関連Pythonパッケージの管理。

## 移植作業の進め方（TODO）

1.  **ファイル構成の見直し:**
    - `.bat`ファイルを`.sh`ファイルにリネームしたファイルを新規作成します。
2.  **`InstallerTemplate.bat`の移植:**
    - `InstallerTemplate.sh`を作成し、全体の処理フローの基礎をLinux向けに再設計します。
3.  **コア機能の移植:**
    - `Git`, `Python`, `Download`ディレクトリ内のスクリプトを優先的に移植します。
    - `Python/Python_Activate.bat` -> `Python/python_activate.sh`: `apt`でのpython-venvの確認と、`python3 -m venv`の実行に置き換えます。
    - `Git/GitHub_CloneOrPull.bat` -> `Git/github_clone_or_pull.sh`: `git`コマンドは共通ですが、パスの扱いなどを修正します。
4.  **アプリケーション管理スクリプトの移植:**
    - `ComfyUi`, `LamaCleaner`等のスクリプトを、移植したコア機能を利用して再実装します。

## 新しい開発規約 (Linux版)

- **Shebang:** すべてのシェルスクリプトの1行目には `#!/bin/bash` を記述します。
- **実行権限:** 作成した `.sh` ファイルには実行権限 (`chmod +x`) を付与します。
- **変数:** 変数定義は `VAR="VALUE"` の形式で行い、参照時はダブルクォートで囲みます (`"$VAR"`)。
- **エラーハンドリング:** コマンドの実行後には `if [ $? -ne 0 ]; then ... fi` の形式でエラーチェックを適切に行います。
- **可読性:** コメントを活用し、複雑な処理にはその意図を明記します。

## タスク分割方針

- 巨大なタスクを作ることは避けて、小さなタスクに分割して作業を行う。
- タスクごとにブランチを作成する。
- ある程度の作業単位の完了段階で都度コミットする。
- タスクの完了時にプッシュ及びプルリクエストの作成を行う。




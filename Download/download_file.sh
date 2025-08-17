#!/bin/bash
set -euo pipefail

# 汎用ダウンロードスクリプト (aria2c / curl)
# 使い方:
#   bash Download/download_file.sh --url <URL> [--out <path>] [--outdir <dir>] [--use aria|curl] [--force] [--header "K: V"]...

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"

usage() {
  cat <<'USAGE'
使い方:
  bash Download/download_file.sh --url <URL> [--out <path>] [--outdir <dir>] [--use aria|curl] [--force] [--header "K: V"]...

オプション:
  --url <URL>      : ダウンロード先URL（必須）
  --out <path>     : 出力ファイルパス（省略時はURL末尾のファイル名）
  --outdir <dir>   : 出力ディレクトリ（--out未指定時に使用）
  --use <tool>     : 強制的に 'aria' または 'curl' を使用
  --force          : 既存ファイルがあっても上書き
  --header "K: V"  : HTTPヘッダを追加（複数指定可）
  -h, --help       : このヘルプを表示

例:
  bash Download/download_file.sh --url https://example.com/file.zip --outdir Download
USAGE
}

log() { echo "[INFO] $*"; }
err() { echo "[ERROR] $*" >&2; }

URL=""
OUT=""
OUTDIR=""
TOOL="auto"
FORCE="no"
HEADERS=()

while [ $# -gt 0 ]; do
  case "$1" in
    --url)     shift; URL="${1:-}" ;;
    --out)     shift; OUT="${1:-}" ;;
    --outdir)  shift; OUTDIR="${1:-}" ;;
    --use)     shift; TOOL="${1:-auto}" ;;
    --force)   FORCE="yes" ;;
    --header)  shift; HEADERS+=("${1:-}") ;;
    -h|--help) usage; exit 0 ;;
    *) ;;
  esac
  shift || true
done

if [ -z "$URL" ]; then
  err "--url は必須です"
  usage
  exit 1
fi

filename_from_url() {
  local u="$1"
  basename "${u%%\?*}"
}

if [ -z "$OUT" ]; then
  base="$(filename_from_url "$URL")"
  if [ -n "$OUTDIR" ]; then
    mkdir -p "$OUTDIR"
    OUT="$OUTDIR/$base"
  else
    OUT="$base"
  fi
else
  mkdir -p "$(dirname "$OUT")"
fi

if [ -f "$OUT" ] && [ "$FORCE" = "no" ]; then
  log "既に存在します: $OUT (スキップ)"
  exit 0
fi

use_tool=""
if [ "$TOOL" = "auto" ]; then
  if command -v aria2c >/dev/null 2>&1; then
    use_tool="aria"
  elif command -v curl >/dev/null 2>&1; then
    use_tool="curl"
  else
    err "aria2c も curl も見つかりません。apt でインストールしてください。"
    exit 1
  fi
else
  use_tool="$TOOL"
fi

log "ダウンロード開始: $URL -> $OUT"
if [ "$use_tool" = "aria" ]; then
  args=("-x16" "-s16" "-k1M" "-o" "$OUT")
  for h in "${HEADERS[@]:-}"; do args+=("--header=$h"); done
  aria2c "${args[@]}" "$URL"
else
  args=("-L" "-f" "-o" "$OUT")
  for h in "${HEADERS[@]:-}"; do args+=("-H" "$h"); done
  curl "${args[@]}" "$URL"
fi

log "ダウンロード完了: $OUT"


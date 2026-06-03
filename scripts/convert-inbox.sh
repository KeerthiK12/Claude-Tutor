#!/usr/bin/env bash
set -euo pipefail

VAULT_DIR="${VAULT_DIR:-$HOME/dev-vault}"
INBOX="$VAULT_DIR/classes/_inbox"
OUT="$VAULT_DIR/classes/_converted"
MARKITDOWN="${MARKITDOWN:-$HOME/.local/bin/markitdown}"

mkdir -p "$OUT"

if [[ ! -x "$MARKITDOWN" ]]; then
  echo "MarkItDown wrapper not found at: $MARKITDOWN" >&2
  echo "Run ./scripts/setup.sh first, or set MARKITDOWN=/path/to/markitdown." >&2
  exit 1
fi

find "$INBOX" -maxdepth 1 -type f \( \
  -iname "*.pdf" -o \
  -iname "*.pptx" -o \
  -iname "*.docx" -o \
  -iname "*.html" -o \
  -iname "*.htm" \
\) | while IFS= read -r file; do
  base="$(basename "$file")"
  name="${base%.*}"
  out="$OUT/$name.md"
  printf 'Converting %s -> %s\n' "$base" "$out"
  "$MARKITDOWN" "$file" -o "$out"
done


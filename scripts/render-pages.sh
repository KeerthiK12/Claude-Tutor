#!/usr/bin/env bash
set -euo pipefail

PYTHON="${MARKITDOWN_PYTHON:-$HOME/.local/venvs/markitdown/bin/python}"
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

if [[ ! -x "$PYTHON" ]]; then
  echo "MarkItDown virtualenv Python not found at: $PYTHON" >&2
  echo "Run ./scripts/setup.sh first, or set MARKITDOWN_PYTHON=/path/to/python." >&2
  exit 1
fi

"$PYTHON" "$SCRIPT_DIR/render-pdf-pages.py" "$@"


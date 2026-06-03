#!/usr/bin/env bash
set -euo pipefail

REPO_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
VAULT_DIR="${VAULT_DIR:-$HOME/dev-vault}"
CLAUDE_DIR="${CLAUDE_DIR:-$HOME/.claude}"
LOCAL_BIN="${LOCAL_BIN:-$HOME/.local/bin}"
MARKITDOWN_VENV="${MARKITDOWN_VENV:-$HOME/.local/venvs/markitdown}"

echo "Setting up Claude PDF Tutor"
echo "Repo:       $REPO_ROOT"
echo "Course dir: $VAULT_DIR/classes"
echo

mkdir -p \
  "$CLAUDE_DIR/skills" \
  "$LOCAL_BIN" \
  "$HOME/.local/venvs" \
  "$VAULT_DIR/classes/_inbox" \
  "$VAULT_DIR/classes/_converted" \
  "$VAULT_DIR/classes/_pages"

echo "Installing lecture-ingest skill..."
mkdir -p "$CLAUDE_DIR/skills/lecture-ingest"
cp "$REPO_ROOT/skills/lecture-ingest/SKILL.md" "$CLAUDE_DIR/skills/lecture-ingest/SKILL.md"

echo "Installing class workflow files..."
cp "$REPO_ROOT/templates/classes/README.md" "$VAULT_DIR/classes/README.md"
cp "$REPO_ROOT/scripts/convert-inbox.sh" "$VAULT_DIR/classes/convert-inbox.sh"
cp "$REPO_ROOT/scripts/render-pages.sh" "$VAULT_DIR/classes/render-pages.sh"
cp "$REPO_ROOT/scripts/render-pdf-pages.py" "$VAULT_DIR/classes/render-pdf-pages.py"
chmod +x "$VAULT_DIR/classes/convert-inbox.sh" "$VAULT_DIR/classes/render-pages.sh" "$VAULT_DIR/classes/render-pdf-pages.py"

if [[ ! -x "$MARKITDOWN_VENV/bin/python" ]]; then
  echo "Creating MarkItDown virtualenv..."
  python3 -m venv "$MARKITDOWN_VENV"
fi

echo "Installing MarkItDown into dedicated virtualenv..."
"$MARKITDOWN_VENV/bin/python" -m pip install --upgrade pip
"$MARKITDOWN_VENV/bin/python" -m pip install 'markitdown[pdf,docx,pptx]'

echo "Creating markitdown wrapper..."
cat > "$LOCAL_BIN/markitdown" <<EOF
#!/usr/bin/env sh
exec "$MARKITDOWN_VENV/bin/markitdown" "\$@"
EOF
chmod +x "$LOCAL_BIN/markitdown"

ensure_path_line() {
  local shell_file="$1"
  local line='export PATH="$HOME/.local/bin:$PATH"'
  touch "$shell_file"
  if ! grep -Fq "$line" "$shell_file"; then
    printf '\n%s\n' "$line" >> "$shell_file"
  fi
}

echo "Adding ~/.local/bin to common shell profiles..."
ensure_path_line "$HOME/.zshrc"
ensure_path_line "$HOME/.bash_profile"

echo
echo "Done."
echo
echo "Next steps:"
echo "1. Put PDFs/PPTX/DOCX into: $VAULT_DIR/classes/_inbox"
echo "2. Convert text: $VAULT_DIR/classes/convert-inbox.sh"
echo "3. Render PDF pages: $VAULT_DIR/classes/render-pages.sh"
echo "4. Start Claude Code UI or terminal in: $VAULT_DIR/classes"
echo "5. Ask Claude: Use the lecture-ingest skill."

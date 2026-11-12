#!/usr/bin/env bash
# Set up a Mac from this repo. Safe to re-run.
# Existing files are moved to <file>.pre-dotfiles before being replaced by a symlink.
set -euo pipefail
DOT="$(cd "$(dirname "$0")" && pwd)"

link() {  # link <repo path> <target>
  local src="$DOT/$1" dst="$2"
  mkdir -p "$(dirname "$dst")"
  if [ -L "$dst" ] && [ "$(readlink "$dst")" = "$src" ]; then return; fi
  [ -e "$dst" ] || [ -L "$dst" ] && mv "$dst" "$dst.pre-dotfiles"
  ln -s "$src" "$dst"
  echo "linked $dst"
}

# 1. Homebrew + packages
if ! command -v brew >/dev/null; then
  /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
  eval "$(/opt/homebrew/bin/brew shellenv)"
fi
brew bundle --file="$DOT/Brewfile" || echo "brew bundle: some entries failed; see output above"

# 2. uv (provides uvx, used by claude-thermos)
command -v uv >/dev/null || curl -LsSf https://astral.sh/uv/install.sh | sh

# 3. Oh My Zsh (unattended; keeps our .zshrc)
[ -d "$HOME/.oh-my-zsh" ] || RUNZSH=no KEEP_ZSHRC=yes sh -c \
  "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended

# 4. Shell + git
link zsh/.zshrc      "$HOME/.zshrc"
link zsh/.zprofile   "$HOME/.zprofile"
link git/.gitconfig  "$HOME/.gitconfig"
link git/ignore      "$HOME/.config/git/ignore"
[ -f "$HOME/.zshrc.local" ] || printf '# Machine-local secrets and work-only aliases. Never commit.\n' > "$HOME/.zshrc.local"
[ -f "$HOME/.gitconfig.local" ] || printf '[user]\n\tname = \n\temail = \n' > "$HOME/.gitconfig.local"

# 5. Claude Code
link claude/settings.json             "$HOME/.claude/settings.json"
link claude/statusline.sh             "$HOME/.claude/statusline.sh"
link claude/CLAUDE.md                 "$HOME/.claude/CLAUDE.md"
link claude/output-styles/rationale.md "$HOME/.claude/output-styles/rationale.md"
for s in "$DOT"/claude/skills/*/; do
  link "claude/skills/$(basename "$s")" "$HOME/.claude/skills/$(basename "$s")"
done

# 6. claude-thermos: keeps Claude Code's prompt cache warm (LaunchAgent on :8787)
plist="$HOME/Library/LaunchAgents/com.claude-thermos.serve.plist"
mkdir -p "$HOME/.claude-thermos/logs" "$(dirname "$plist")"
sed "s#__HOME__#$HOME#g" "$DOT/claude/com.claude-thermos.serve.plist" > "$plist"
launchctl bootout "gui/$(id -u)" "$plist" 2>/dev/null || true
launchctl bootstrap "gui/$(id -u)" "$plist" && echo "claude-thermos started"

# 7. Editors
link vscode/settings.json "$HOME/Library/Application Support/Code/User/settings.json"
link zed/settings.json    "$HOME/.config/zed/settings.json"
if command -v code >/dev/null; then
  xargs -n1 code --install-extension < "$DOT/vscode/extensions.txt"
fi

cat <<'EOF'

Done. Manual steps:
  - Fill in ~/.gitconfig.local (name, email).
  - Put API keys in ~/.zshrc.local.
  - Claude Code plugins: run /plugin and enable mattpocock-skills, posthog (claude-plugins-official), gddy (godaddy marketplace).
  - MCP: claude mcp add --transport http sequel https://api.sequel.sh/mcp --header "Authorization: Bearer <key>"
  - Open a new terminal.
EOF

# --- Oh My Zsh ---
export ZSH="$HOME/.oh-my-zsh"
ZSH_THEME="robbyrussell"
HIST_STAMPS="yyyy-mm-dd"
plugins=(git history)
source $ZSH/oh-my-zsh.sh

# --- Shell history ---
HISTFILE="$HOME/.zsh_history"
HISTSIZE=50000
SAVEHIST=50000
setopt EXTENDED_HISTORY       # save timestamp + duration per command
setopt INC_APPEND_HISTORY     # write each command as it runs, not on shell exit
setopt SHARE_HISTORY          # sync history live across open terminals
setopt HIST_IGNORE_ALL_DUPS   # remove older duplicate when a repeated command is added
setopt HIST_IGNORE_SPACE      # don't record commands starting with a space
setopt HIST_REDUCE_BLANKS     # strip superfluous blanks before recording
setopt HIST_VERIFY            # expand !-history refs into the buffer without running immediately

# --- nvm ---
export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"

# --- pyenv ---
if command -v pyenv >/dev/null; then
  export PYENV_ROOT="$HOME/.pyenv"
  export PATH="$PYENV_ROOT/bin:$PATH"
  eval "$(pyenv init --path)"
  eval "$(pyenv init -)"
fi

# --- PATH ---
export PATH="$HOME/.local/bin:$PATH"                      # uv, uvx, user CLIs
[ -d /opt/homebrew/opt/openjdk@21/bin ] && export PATH="/opt/homebrew/opt/openjdk@21/bin:$PATH"
[ -d "$HOME/.opencode/bin" ] && export PATH="$HOME/.opencode/bin:$PATH"

# --- Claude Code prompt-cache warming (claude-thermos) ---
# Only route through the local proxy when it is actually listening; otherwise
# Claude Code would fail every request on a machine where the daemon is down.
if nc -z 127.0.0.1 8787 2>/dev/null; then
  export ANTHROPIC_BASE_URL=http://127.0.0.1:8787
fi

# --- Vercel: per-repo account ---
# A repo picks its account with a `.vercel-account` file at the repo root.
# The file holds an account name; its login lives in ~/.vercel-accounts/<name>.
# No file = the default CLI login.
vercel() {
  local dir="$PWD" name=""
  while [[ -n "$dir" ]]; do
    [[ -f "$dir/.vercel-account" ]] && { name=$(<"$dir/.vercel-account"); break; }
    dir="${dir%/*}"
  done
  if [[ -n "$name" ]]; then
    command vercel --global-config "$HOME/.vercel-accounts/$name" "$@"
  else
    command vercel "$@"
  fi
}

# --- direnv: load per-repo .envrc ---
command -v direnv >/dev/null && eval "$(direnv hook zsh)"

# devctx: show which Git, SSH, gh and Vercel identity the current folder uses. `devctx -v` also asks GitHub/Vercel live.
devctx() {
  local top; top=$(git rev-parse --show-toplevel 2>/dev/null) || { echo "not in a git repo"; return 1; }
  echo "repo     $(basename "$top")  ($(git remote get-url origin 2>/dev/null))"
  echo "git      $(git config user.name) <$(git config user.email)>  [$(git config --show-origin user.name | cut -f1 | sed "s|file:$HOME|~|")]"
  echo "ssh      ${$(git config core.sshCommand):-default key (~/.ssh/id_ed25519)}"
  if [[ -n "$GH_TOKEN" ]]; then echo "gh       token from env (this folder)"; else echo "gh       active account (gh auth switch)"; fi
  if [[ -n "$VERCEL_TOKEN" ]]; then echo "vercel   token from env (this folder)"; else echo "vercel   default CLI login"; fi
  [[ "$1" == "-v" ]] || return 0
  echo "live gh      $(gh api user --jq .login 2>/dev/null)"
  echo "live vercel  $(vercel whoami 2>/dev/null | tail -1)"
}

# --- Machine-local: secrets, API keys, work-only aliases. Never committed. ---
[ -f "$HOME/.zshrc.local" ] && source "$HOME/.zshrc.local"

# dotfiles

My Mac terminal, git, editor and Claude Code setup.

## Install

```sh
git clone <this repo> ~/dotfiles
~/dotfiles/install.sh
```

The script installs Homebrew, the Brewfile, uv and Oh My Zsh. Then it symlinks the files below into `~`.
It moves any file it replaces to `<file>.pre-dotfiles`. It is safe to run more than once.

## What's here

| Path | Goes to | Notes |
|---|---|---|
| `zsh/.zshrc`, `zsh/.zprofile` | `~` | Oh My Zsh (`robbyrussell`), 50k shared history, nvm, pyenv, direnv, `vercel` per-repo account switcher, `devctx`. Sources `~/.zshrc.local` last. |
| `git/.gitconfig` | `~` | No identity. It includes `~/.gitconfig.local`. |
| `git/ignore` | `~/.config/git/ignore` | Global gitignore. |
| `claude/settings.json` | `~/.claude/` | Theme `dark-daltonized`, status line, effort levels, 1h subagent prompt-cache TTL, plugins. |
| `claude/CLAUDE.md` | `~/.claude/` | Global instruction: refine every substantive prompt into a principal-engineer framing first. |
| `claude/statusline.sh` | `~/.claude/` | Model, effort and context-window bar. Needs `jq`. |
| `claude/output-styles/rationale.md` | `~/.claude/output-styles/` | "Rationale" output style. |
| `claude/skills/` | `~/.claude/skills/` | `rehearse` (mine), `stop-slop` (MIT, Hardik Pandya). |
| `claude/com.claude-thermos.serve.plist` | `~/Library/LaunchAgents/` | Runs `uvx claude-thermos serve --port 8787` to keep the prompt cache warm. `.zshrc` sets `ANTHROPIC_BASE_URL` only when the port is listening. |
| `vscode/`, `zed/` | app config dirs | Settings and the extension list. |
| `Brewfile` | — | `brew bundle --file=Brewfile` |

## Claude Code setup

What a session looks like:

```
❯ █
  [Opus 5.5] | effort:high ▓░░░░░░░░░ 9% (89.6k/1000.0k)
  ▸▸ bypass permissions on (shift+tab to cycle)
```

| You see | Where it comes from |
|---|---|
| `[Opus 5.5] \| effort:high ▓░░ 9% (89.6k/1000.0k)` | `claude/statusline.sh`, wired in `settings.json` → `statusLine`. It shows the model, the effort level and the context-window use. The bar is blue below 70%, orange below 90% and bold vermillion with a `!` from 90%. |
| `effort:high` | `settings.json` → `effortLevel: "high"`, plus per-model overrides in `modelSettings`. |
| `bypass permissions on` | **Not in settings.** It comes from the launch command: `claude --dangerously-skip-permissions --chrome`. `settings.json` keeps `permissions.defaultMode: "default"`, so a plain `claude` asks before each tool call. The repo leaves out `skipDangerousModePermissionPrompt`, so a new machine confirms bypass mode once. |
| Colours | `theme: "dark-daltonized"` (colour-blind safe). |
| Fullscreen UI, timestamps, turn time | `tui: "fullscreen"`, `showMessageTimestamps`, `showTurnDuration`. |

### Colour-blind-friendly elements

Every signal pairs colour with a shape or text, so no meaning depends on colour alone.

| Element | Colour-blind-safe treatment | Source |
|---|---|---|
| Diff: added lines | Blue background (not green), `+` in the gutter | `theme: "dark-daltonized"` |
| Diff: removed lines | Warm background (not red), `-` in the gutter | `theme: "dark-daltonized"` |
| Edit summary (`Added 26 lines`) | Text count, no colour needed | Built into Claude Code |
| Context bar | Blue → orange → bold vermillion + `!` (Okabe-Ito) | `claude/statusline.sh` |
| Bar fill | `▓` used, `░` free: readable without colour | `claude/statusline.sh` |
| Permission mode | Text label (`bypass permissions on`) and `▸▸` | Built into Claude Code |

Other daltonized option: `light-daltonized`. To use your terminal's own palette instead, use `dark-ansi` or `light-ansi`. Change the theme with `/config` or the `theme` key.

Other behaviour:

- **Prompt refining**: `claude/CLAUDE.md`. Every substantive reply starts with a *Refined prompt* and *Framing note* block.
- **Output style**: `Rationale` everywhere (`claude/output-styles/rationale.md`). A project can override it in its own `.claude/settings.local.json`, for example `"outputStyle": "Concise"`.
- **Prompt cache**: `subagentPromptCacheTtl: "1h"` keeps subagent prompts cached for an hour. claude-thermos (LaunchAgent, port 8787) keeps the main agent's cache warm. `autoCompactEnabled: false` stops automatic compaction from rewriting the cached prefix.
- **Voice**: hold-to-talk (`voice.mode: "hold"`).
- **Plugins**: `mattpocock-skills`, `posthog` (claude-plugins-official), `gddy` (godaddy marketplace). Enable them with `/plugin` after install.

## Kept out on purpose

- Secrets and API keys: put them in `~/.zshrc.local`.
- Git name, email and per-account identities: put them in `~/.gitconfig.local`.
- `~/.ssh`, `~/.claude.json`, `~/.claude/projects`, shell history.
- MCP servers with tokens in the URL or headers. Add them again by hand.
- `skipDangerousModePermissionPrompt`: decide this for each machine.
- Third-party skills that have their own installer, such as `sequel`.

## Terminal

Terminal.app with the built-in **Clear Dark** profile (Settings > Profiles > Clear Dark > Default).

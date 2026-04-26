# dotfiles

Personal config managed with [GNU Stow](https://www.gnu.org/software/stow/).

## Layout

Each top-level directory is a stow package. Its contents mirror the target paths under `$HOME`:

| Package   | Target                                                |
| --------- | ----------------------------------------------------- |
| `alacritty`| `~/.config/alacritty/`                               |
| `helix`   | `~/.config/helix/`                                    |
| `zellij`  | `~/.config/zellij/`                                   |
| `yazi`    | `~/.config/yazi/`                                     |
| `karabiner`| `~/.config/karabiner/` (macOS only)                  |
| `yabai`   | `~/.config/yabai/` (macOS only)                       |
| `lazygit` | `~/Library/Application Support/lazygit/` (macOS path) |
| `bin`     | `~/bin/`                                              |
| `zsh`     | `~/` (`.zshrc`, `.zprofile`, `.zshenv`)               |

## Bootstrap on a new machine

```sh
# 1. install prerequisites
brew install stow alacritty helix zellij yazi lazygit git-delta

# 2. clone this repo
git clone <REMOTE_URL> ~/dotfiles
cd ~/dotfiles

# 3. stow everything (most packages target $HOME via .config)
stow alacritty helix zellij yazi bin karabiner yabai

# 4. packages that live directly under $HOME need an explicit target
stow --target="$HOME" lazygit zsh

# 5. create local overrides (see "Local overrides" section below)
$EDITOR ~/.zshrc.local
```

## Local overrides (`~/.zshrc.local`)

`.zshrc` sources `~/.zshrc.local` at its tail if present. The local file
holds anything that is machine-specific, sensitive, or workplace-private
and must NOT be committed.

Typical contents on this machine:

```sh
# Convenience hashes / personal secrets
alias qaz='echo <some-hash>'

# Internal SSH hosts (work infra)
alias node1='ssh user@node1.example.internal'
# ... more aliases ...

# Pinned tool paths (machine-specific install locations)
export JAVA_HOME=/Library/Java/JavaVirtualMachines/jdk1.8.0_111.jdk/Contents/Home
export HELIX_RUNTIME=~/src/helix/runtime

# Development tools installed under $HOME/development (or wherever)
export PATH="$HOME/development/gradle-6.3/bin:$PATH"
export PATH="$HOME/development/google-cloud-sdk/bin:$PATH"
export PATH="$HOME/development/maven/bin:$PATH"
# ... etc ...

# Workspace cd shortcuts (paths specific to this checkout layout)
alias monorepo='cd /Users/me/workspaces/idea/monorepo'
# ... etc ...
```

Guarded by `zsh/.zshrc.local` in `.gitignore` as a safety net.

## Stack overview

- **Alacritty** — GPU-accelerated terminal emulator
- **Helix** — modal editor
- **Zellij** — terminal multiplexer; `wt <name>` (in `bin/`) launches per-worktree sessions with editor / shell / agent / logs tabs
- **Yazi** — file manager, opens files in the running Helix pane via `zjctl`
- **LazyGit** — git TUI, `e` opens files in the running Helix pane via `zjctl`
- **zjctl** — out-of-band Zellij pane control, install with `cargo install zjctl && zjctl install --load`

## Notes

- `bin/wt` is a launcher script; assumes worktrees live at `~/workspaces/idea/monorepo*` and `~/workspaces/infra/{fleet,cloud}-infra`. Edit the case statement for your own layout.
- `lazygit` overrides the built-in `e` keybinding (`universal.edit` is moved to `<c-e>`) so a custom command can dispatch to Helix.
- Helix uses `Ctrl-g` for LazyGit and `Ctrl-e` for Yazi (both spawn floating Zellij panes).
- Zellij runs in `locked` mode by default; `Alt-z` unlocks; `Alt-h/l` and `Alt-1..5` navigate tabs without leaving locked mode.

## Unstowing

```sh
cd ~/dotfiles
stow -D alacritty helix zellij yazi bin
stow -D --target="$HOME" lazygit zsh
```

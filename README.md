# dotfiles

Personal config managed with [GNU Stow](https://www.gnu.org/software/stow/).

## Layout

Each top-level directory is a stow package. Its contents mirror the target paths under `$HOME`:

| Package   | Target                                                |
| --------- | ----------------------------------------------------- |
| `alacritty`| `~/.config/alacritty/`                               |
| `kitty`   | `~/.config/kitty/`                                    |
| `helix`   | `~/.config/helix/`                                    |
| `nvim`    | `~/.config/nvim/`                                     |
| `tmux`    | `~/.config/tmux/`                                     |
| `yazi`    | `~/.config/yazi/`                                     |
| `karabiner`| `~/.config/karabiner/` (macOS only)                  |
| `yabai`   | `~/.config/yabai/` (macOS only)                       |
| `lazygit` | `~/Library/Application Support/lazygit/` (macOS path) |
| `bin`     | `~/bin/`                                              |
| `zsh`     | `~/` (`.zshrc`, `.zprofile`, `.zshenv`)               |

## Bootstrap on a new machine

```sh
# 1. install prerequisites
brew install stow alacritty kitty helix neovim tmux yazi lazygit git-delta

# 2. clone this repo
git clone <REMOTE_URL> ~/dotfiles
cd ~/dotfiles

# 3. stow everything (most packages target $HOME via .config)
stow alacritty kitty helix nvim tmux yazi bin karabiner yabai

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
alias monorepo='cd /Users/me/work/monorepo'
# ... etc ...
```

Guarded by `zsh/.zshrc.local` in `.gitignore` as a safety net.

## Stack overview

- **Alacritty** — GPU-accelerated terminal emulator
- **Helix** — previous modal editor config kept around
- **Neovim** — current modal editor config with built-in LSP and Go/Bazel shortcuts
- **tmux** — terminal multiplexer; `prefix` is `C-a`, `prefix f` runs `tmux-sessionizer`
- **Yazi** — file manager, opens files in the running Neovim instance
- **LazyGit** — git TUI, opens files in the running Neovim instance

## Notes

- `nvim-session` starts Neovim with a fixed RPC socket so Yazi and LazyGit can reuse the running editor.
- Yazi and LazyGit call `nvim-open`, which opens files in the active Neovim server when available.

## Unstowing

```sh
cd ~/dotfiles
stow -D alacritty helix nvim tmux yazi bin
stow -D --target="$HOME" lazygit zsh
```

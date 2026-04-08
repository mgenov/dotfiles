# dotfiles

Personal config managed with [GNU Stow](https://www.gnu.org/software/stow/).

## Layout

Each top-level directory is a stow package. Its contents mirror the target paths under `$HOME`:

| Package   | Target                                                |
| --------- | ----------------------------------------------------- |
| `helix`   | `~/.config/helix/`                                    |
| `zellij`  | `~/.config/zellij/`                                   |
| `yazi`    | `~/.config/yazi/`                                     |
| `lazygit` | `~/Library/Application Support/lazygit/` (macOS path) |
| `bin`     | `~/bin/`                                              |

## Bootstrap on a new machine

```sh
# 1. install prerequisites
brew install stow helix zellij yazi lazygit git-delta

# 2. clone this repo
git clone <REMOTE_URL> ~/dotfiles
cd ~/dotfiles

# 3. stow everything (most packages target $HOME via .config)
stow helix zellij yazi bin

# 4. lazygit lives outside ~/.config; needs an explicit target
stow --target="$HOME" lazygit
```

## Stack overview

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
stow -D helix zellij yazi bin
stow -D --target="$HOME" lazygit
```

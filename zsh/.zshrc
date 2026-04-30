export ZSH=/Users/mgenov/.oh-my-zsh
ZSH_THEME="cloud"

# Which plugins would you like to load? (plugins can be found in ~/.oh-my-zsh/plugins/*)
# Custom plugins may be added to ~/.oh-my-zsh/custom/plugins/
# Example format: plugins=(rails git textmate ruby lighthouse)
# Add wisely, as too many plugins slow down shell startup.
# fzf-tab must load after compinit (oh-my-zsh handles this) and before
# zsh-autosuggestions/zsh-syntax-highlighting. zsh-syntax-highlighting must be last.
plugins=(git fzf-tab zsh-nvm zsh-autosuggestions zsh-syntax-highlighting)

fpath=($HOME/bin $fpath)
source $ZSH/oh-my-zsh.sh

# fzf key bindings (Ctrl-R history, Ctrl-T files, Alt-C cd) and completion.
[[ -o interactive ]] && command -v fzf >/dev/null && source <(fzf --zsh)


export PATH=/usr/local/sbin:/usr/local/bin:${PATH}
export PATH="$HOME/bin:$PATH"
export PATH="$HOME/.local/bin:$PATH"

export GOPATH=$HOME
export GRADLE_OPTS=-Xmx1536m
export PATH="$PATH:$HOME/development/go/bin/:$GOPATH/bin"
export ANDROID_HOME="$HOME/development/android-sdk-macosx"
export NVIM_SOCKET="${XDG_RUNTIME_DIR:-$HOME/.cache}/nvim/editor.sock"
export KUBE_EDITOR="$HOME/bin/nvim-open"
export EDITOR="$HOME/bin/nvim-open"
export VISUAL="$HOME/bin/nvim-open"

v() {
  "$HOME/bin/nvim-open" "$@"
}
export PATH="$PATH:$ANDROID_HOME/tools"
export PATH="$PATH:$ANDROID_HOME/platform-tools"
export PATH="$HOME/.yarn/bin:$PATH"
export PATH="./node_modules/.bin:$PATH"
export PATH="/opt/homebrew/opt/mongodb-community@5.0/bin:$PATH"

alias gs=git-spice
eval "$(git-spice shell completion zsh)"

if type nvim > /dev/null 2>&1; then
  alias vim='$HOME/bin/nvim-open'
  alias vi='$HOME/bin/nvim-open'
fi
alias x='claude --dangerously-skip-permissions'
alias cc='claude'
alias ls='ls -G'
alias ll='ls -lG'
alias duh='du -csh'
export LSCOLORS="ExGxBxDxCxEgEdxbxgxcxd"
export GREP_OPTIONS="--color"

# Unbreak history
export HISTSIZE=100000
export HISTFILE="$HOME/.history"
export SAVEHIST=$HISTSIZE

# Unbreak Python's error-prone .pyc file generation

export WORDCHARS='*?[]~&;!$%^<>'

export ACK_COLOR_MATCH='red'

# GIT helper functions
function fetchpl() 
{
    git checkout master
    git fetch origin pull/$1/head:pr/$1
    git checkout pr/$1
    git rebase master
}
function checkpl() {
    git checkout master
    git fetch upstream pull/$1/head:pr/$1
    git checkout pr/$1
}


# bun completions
[ -s "/Users/mgenov/.bun/_bun" ] && source "/Users/mgenov/.bun/_bun"

# bun
export BUN_INSTALL="$HOME/.bun"
export PATH="$BUN_INSTALL/bin:$PATH"

# nvm is loaded lazily via the zsh-nvm plugin (NVM_LAZY=true by default).
#compdef gt
###-begin-gt-completions-###
#
# yargs command completion script
#
# Installation: gt completion >> ~/.zshrc
#    or gt completion >> ~/.zprofile on OSX.
#
_gt_yargs_completions()
{
  local reply
  local si=$IFS
  IFS=$'
' reply=($(COMP_CWORD="$((CURRENT-1))" COMP_LINE="$BUFFER" COMP_POINT="$CURSOR" gt --get-yargs-completions "${words[@]}"))
  IFS=$si
  _describe 'values' reply
}
compdef _gt_yargs_completions gt
###-end-gt-completions-###

# Local overrides: secrets, internal SSH aliases, machine-specific config.
# Not version-controlled. See ~/.zshrc.local.
[ -f "$HOME/.zshrc.local" ] && source "$HOME/.zshrc.local"

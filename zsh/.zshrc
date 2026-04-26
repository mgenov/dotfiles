export ZSH=/Users/mgenov/.oh-my-zsh
ZSH_THEME="cloud"

# Which plugins would you like to load? (plugins can be found in ~/.oh-my-zsh/plugins/*)
# Custom plugins may be added to ~/.oh-my-zsh/custom/plugins/
# Example format: plugins=(rails git textmate ruby lighthouse)
# Add wisely, as too many plugins slow down shell startup.
plugins=(git)

fpath=($HOME/bin $fpath)
source $ZSH/oh-my-zsh.sh


export PATH=/usr/local/sbin:/usr/local/bin:${PATH}
export PATH="$HOME/bin:$PATH"
export PATH="$HOME/.local/bin:$PATH"

export GOPATH=$HOME
export GRADLE_OPTS=-Xmx1536m
export PATH="$PATH:$HOME/development/go/bin/:$GOPATH/bin"
export ANDROID_HOME="$HOME/development/android-sdk-macosx"
export CLOUDSDK_PYTHON=/Users/mgenov/.pyenv/versions/3.10.8/bin/python
# Kitty + Helix: reset default background on exit so transparency survives.
# Helix (or the emulator chain) leaves OSC 11 set to an opaque color, which
# bypasses kitty's background_opacity. OSC 111 reverts to kitty's configured bg.
# Uses ~/bin/hx-term wrapper so child processes (e.g. git's core.editor)
# also reset OSC 11 — shell functions aren't inherited by exec'd children.
export KUBE_EDITOR="$HOME/bin/hx-term"
export EDITOR="$HOME/bin/hx-term"
export VISUAL="$HOME/bin/hx-term"

hx() {
  "$HOME/bin/hx-term" "$@"
}
export PATH="$PATH:$ANDROID_HOME/tools"
export PATH="$PATH:$ANDROID_HOME/platform-tools"
export PATH="$HOME/.yarn/bin:$PATH"
export PATH="./node_modules/.bin:$PATH"
export PATH="/opt/homebrew/opt/mongodb-community@5.0/bin:$PATH"

alias gs=git-spice
eval "$(git-spice shell completion zsh)"

if type nvim > /dev/null 2>&1; then
  alias vim='nvim'
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


#THIS MUST BE AT THE END OF THE FILE FOR SDKMAN TO WORK!!!
export SDKMAN_DIR="/Users/mgenov/.sdkman"
[[ -s "/Users/mgenov/.sdkman/bin/sdkman-init.sh" ]] && source "/Users/mgenov/.sdkman/bin/sdkman-init.sh"

# The next line updates PATH for the Google Cloud SDK.
if [ -f '/Users/mgenov/development/google-cloud-sdk/path.zsh.inc' ]; then . '/Users/mgenov/development/google-cloud-sdk/path.zsh.inc'; fi

# The next line enables shell command completion for gcloud.
if [ -f '/Users/mgenov/development/google-cloud-sdk/completion.zsh.inc' ]; then . '/Users/mgenov/development/google-cloud-sdk/completion.zsh.inc'; fi

PATH="/Users/mgenov/perl5/bin${PATH:+:${PATH}}"; export PATH;
PERL5LIB="/Users/mgenov/perl5/lib/perl5${PERL5LIB:+:${PERL5LIB}}"; export PERL5LIB;
PERL_LOCAL_LIB_ROOT="/Users/mgenov/perl5${PERL_LOCAL_LIB_ROOT:+:${PERL_LOCAL_LIB_ROOT}}"; export PERL_LOCAL_LIB_ROOT;
PERL_MB_OPT="--install_base \"/Users/mgenov/perl5\""; export PERL_MB_OPT;
PERL_MM_OPT="INSTALL_BASE=/Users/mgenov/perl5"; export PERL_MM_OPT;
export PYENV_ROOT="$HOME/.pyenv"
command -v pyenv >/dev/null || export PATH="$PYENV_ROOT/bin:$PATH"
eval "$(pyenv init -)"


# >>> conda initialize >>>
# !! Contents within this block are managed by 'conda init' !!
#__conda_setup="$('/Users/mgenov/miniforge3/bin/conda' 'shell.zsh' 'hook' 2> /dev/null)"
#if [ $? -eq 0 ]; then
#    eval "$__conda_setup"
#else
#    if [ -f "/Users/mgenov/miniforge3/etc/profile.d/conda.sh" ]; then
#        . "/Users/mgenov/miniforge3/etc/profile.d/conda.sh"
#    else
#        export PATH="/Users/mgenov/miniforge3/bin:$PATH"
#    fi
#fi
#unset __conda_setup
# <<< conda initialize <<<


# bun completions
[ -s "/Users/mgenov/.bun/_bun" ] && source "/Users/mgenov/.bun/_bun"

# bun
export BUN_INSTALL="$HOME/.bun"
export PATH="$BUN_INSTALL/bin:$PATH"

export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion
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

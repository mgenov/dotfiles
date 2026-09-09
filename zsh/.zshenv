source "$HOME/.cargo/env"
. "$HOME/.cargo/env"

# ZVM
export ZVM_INSTALL="$HOME/.zvm/self"
if [ -d "$ZVM_INSTALL" ]; then
  export PATH="$PATH:$HOME/.zvm/bin"
  export PATH="$PATH:$ZVM_INSTALL"
fi

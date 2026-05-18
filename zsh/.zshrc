# --- Vim mode ---
if [[ -z ${HOMEBREW_PREFIX:-} && -x /opt/homebrew/bin/brew ]]; then
  export HOMEBREW_PREFIX=/opt/homebrew
fi

source "$HOMEBREW_PREFIX/opt/zsh-vi-mode/share/zsh-vi-mode/zsh-vi-mode.plugin.zsh"

# --- Prompt ---
autoload -Uz vcs_info
precmd() { vcs_info }
zstyle ':vcs_info:git:*' formats ' %F{green}(%b)%f'
setopt PROMPT_SUBST

PROMPT='%F{blue}%~%f${vcs_info_msg_0_} %F{yellow}❯%f '

export PI_OFFLINE=1

# --- NVM ---
export NVM_DIR="$HOME/.nvm"

# Make the default nvm Node available without sourcing nvm on every shell start.
# Handles `nvm alias default node` by resolving `node` to the latest installed version.
_nvm_default_node_version() {
  local alias target
  target="default"

  while [[ -f "$NVM_DIR/alias/$target" ]]; do
    alias="$(< "$NVM_DIR/alias/$target")"
    target="${alias%%#*}"
    target="${target##[[:space:]]}"
    target="${target%%[[:space:]]}"
  done

  if [[ "$target" == node || "$target" == stable || ! -d "$NVM_DIR/versions/node/$target" ]]; then
    command ls -1 "$NVM_DIR/versions/node" 2>/dev/null | command sort -V | command tail -n 1
  else
    echo "$target"
  fi
}

_nvm_default_node="$(_nvm_default_node_version)"
if [[ -n "$_nvm_default_node" && -d "$NVM_DIR/versions/node/$_nvm_default_node/bin" ]]; then
  export PATH="$NVM_DIR/versions/node/$_nvm_default_node/bin:$PATH"
fi
unset _nvm_default_node
unset -f _nvm_default_node_version

# Lazy-load the full nvm script only when you need to switch/install versions.
load_nvm() {
  unset -f nvm 2>/dev/null
  [ -s "$HOMEBREW_PREFIX/opt/nvm/nvm.sh" ] && source "$HOMEBREW_PREFIX/opt/nvm/nvm.sh"
  [ -s "$HOMEBREW_PREFIX/opt/nvm/etc/bash_completion.d/nvm" ] && source "$HOMEBREW_PREFIX/opt/nvm/etc/bash_completion.d/nvm"
}
nvm() { load_nvm; nvm "$@"; }

# Added by get-aspire-cli.sh
export PATH="$HOME/.aspire/bin:$PATH"


# Use for env variables outside of git
LOCAL_ENV="$HOME/.config/zsh/local.env.zsh"
if [[ -f "$LOCAL_ENV" ]]; then
    source "$LOCAL_ENV"
fi

# bun completions
[ -s "/Users/fchamp/.bun/_bun" ] && source "/Users/fchamp/.bun/_bun"

# bun
export BUN_INSTALL="$HOME/.bun"
export PATH="$BUN_INSTALL/bin:$PATH"
export PATH="$PATH:/Users/fchamp/.dotnet/tools"

autoload -Uz add-zsh-hook

_tmux_rename_to_command() {
 [[ -z "$TMUX" ]] && return

 local cmd="${1%% *}"
 cmd="${cmd:t}"

 tmux rename-window "$cmd" 2>/dev/null
}

_tmux_rename_to_shell() {
 [[ -z "$TMUX" ]] && return

 tmux rename-window "${SHELL:t}" 2>/dev/null
}

add-zsh-hook preexec _tmux_rename_to_command
add-zsh-hook precmd _tmux_rename_to_shell


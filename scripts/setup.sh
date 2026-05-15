#!/usr/bin/env bash

set -euo pipefail

DOTFILES="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

GREEN='\033[0;32m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
NC='\033[0m'

ok()   { printf "${GREEN}✓${NC} %s\n" "$1"; }
warn() { printf "${YELLOW}!${NC} %s\n" "$1"; }
err()  { printf "${RED}✗${NC} %s\n" "$1"; }

link() {
  local src="$1"
  local dst="$2"

  if [[ ! -e "$src" ]]; then
    warn "source missing, skipping: $src"
    return
  fi

  if [[ -L "$dst" ]]; then
    if [[ "$(readlink "$dst")" == "$src" ]]; then
      ok "already linked: $dst → $src"
      return
    else
      warn "relinking: $dst (was → $(readlink "$dst"))"
      rm "$dst"
    fi
  elif [[ -e "$dst" ]]; then
    err "target exists and is not a symlink: $dst (remove it manually to proceed)"
    return
  fi

  mkdir -p "$(dirname "$dst")"
  ln -s "$src" "$dst"
  ok "linked: $dst → $src"
}

link "$DOTFILES/nvim"        "$HOME/.config/nvim"
link "$DOTFILES/ghostty"     "$HOME/.config/ghostty"
link "$DOTFILES/.tmux.conf"  "$HOME/.tmux.conf"
link "$DOTFILES/zsh/.zshrc"  "$HOME/.zshrc"

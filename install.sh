#!/usr/bin/env bash
# Symlinks these dotfiles into $HOME. Existing files are moved to ~/.dotfiles-backup/<timestamp>/ first.
set -euo pipefail

DOTFILES_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
BACKUP_DIR="$HOME/.dotfiles-backup/$(date +%Y%m%d-%H%M%S)"

link() {
  local src="$DOTFILES_DIR/$1" dest="$2"
  mkdir -p "$(dirname "$dest")"
  if [[ -L "$dest" && "$(readlink "$dest")" == "$src" ]]; then
    echo "  ok      $dest"
    return
  fi
  if [[ -e "$dest" || -L "$dest" ]]; then
    mkdir -p "$BACKUP_DIR"
    mv "$dest" "$BACKUP_DIR/"
    echo "  backup  $dest -> $BACKUP_DIR/"
  fi
  ln -s "$src" "$dest"
  echo "  linked  $dest"
}

echo "Linking dotfiles from $DOTFILES_DIR"
link zsh/.zshrc              "$HOME/.zshrc"
link nvim/init.lua           "$HOME/.config/nvim/init.lua"
link git/.gitconfig          "$HOME/.gitconfig"
link git/.gitconfig-personal "$HOME/.gitconfig-personal"

if command -v brew >/dev/null 2>&1; then
  echo "Installing CLI tools from Brewfile..."
  brew bundle --file="$DOTFILES_DIR/Brewfile"
else
  echo "Homebrew not found; skipping Brewfile. Install it from https://brew.sh and rerun."
fi

echo "Done. Open a new terminal (or run: source ~/.zshrc)."

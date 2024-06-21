#!/bin/sh

source ./scripts/functions/exists_command.sh
source ./scripts/functions/contains_string.sh

# Directories
mkdir -p ~/.config/alacritty
mkdir -p ~/.config/fish

# Files
[ ! -f "$HOME/.config/fish/config.fish" ] && touch "$HOME/.config/fish/config.fish"

# Homebrew
cp -f ./configs/.Brewfile ~/.Brewfile
if ! exists_command "brew"; then
  /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
fi
brew bundle --global

# Alacritty
cp -f ./configs/alacritty.toml ~/.config/alacritty/alacritty.toml

# Dev Container CLI
mise install node@16
mise install python@3
mise use -g node@16
mise use -g python@3
xcode-select --install || true
npm install -g node-gyp @devcontainers/cli

# fish
FISH_PATH=$(which fish)
chsh -s "$FISH_PATH"
if ! contains_string "fish_greeting" "$HOME/.config/fish/config.fish"; then
  echo 'set fish_greeting' >> ~/.config/fish/config.fish
fi
if ! contains_string "accept-autosuggestion" "$HOME/.config/fish/config.fish"; then
  echo 'bind \t accept-autosuggestion' >> ~/.config/fish/config.fish
fi

# starship
cp -f ./configs/starship.toml ~/.config/starship.toml
if ! contains_string "starship" "$HOME/.config/fish/config.fish"; then
  echo 'starship init fish | source' >> ~/.config/fish/config.fish
fi

# zoxide
if ! contains_string "zoxide" "$HOME/.config/fish/config.fish"; then
  echo 'eval (zoxide init fish)' >> ~/.config/fish/config.fish
fi

# TODO: `nvim.sh` のシムリンクを /usr/local/bin に作成し、`nvim` コマンドで実行できるようにする

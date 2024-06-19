#!/bin/sh

# Directories
mkdir -p ~/.config/alacritty
mkdir -p ~/.config/fish

# Homebrew
cp -f ./configs/.Brewfile ~/.Brewfile
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
brew bundle --global

# Alacritty
cp -f ./configs/alacritty.toml ~/.config/alacritty/alacritty.toml

# Dev Container CLI
mise install node@16
mise install python@3
mise use -g node@16
mise use -g python@3
xcode-select --install
npm install -g node-gyp @devcontainers/cli

# fish
FISH_PATH=$(which fish)
chsh -s "$FISH_PATH"

# starship
cp -f ./configs/starship.toml ~/.config/starship.toml
echo 'starship init fish | source' >> ~/.config/fish/config.fish

# zoxide
echo 'eval (zoxide init fish)' >> ~/.config/fish/config.fish

# TODO: `nvim.sh` のシムリンクを /usr/local/bin に作成し、`nvim` コマンドで実行できるようにする

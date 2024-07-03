#!/bin/sh

while getopts "n:e:" opt; do
  case $opt in
    n) GIT_USER_NAME="$OPTARG" ;;
    e) GIT_USER_EMAIL="$OPTARG" ;;
  esac
done

source ./scripts/functions/exists_command.sh
source ./scripts/functions/contains_string.sh
source ./scripts/functions/is_ubuntu.sh

# Directories
mkdir -p ~/.config/alacritty
mkdir -p ~/.config/fish

# Files
[ ! -f "$HOME/.config/fish/config.fish" ] && touch "$HOME/.config/fish/config.fish"

# Homebrew
cp -f ./configs/.Brewfile ~/.Brewfile
if ! exists_command "brew"; then
  /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
  if is_ubuntu; then
    (echo; echo 'eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"') >> "$HOME/.bashrc"
    eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"
  fi
fi
brew bundle --global

# Alacritty
cp -f ./configs/alacritty.toml ~/.config/alacritty/alacritty.toml

# AstroNvim
if [ ! -d "$HOME/.config/nvim" ]; then
  # git clone https://github.com/AstroNvim/AstroNvim ~/.config/nvim
  git clone --depth 1 https://github.com/AstroNvim/template ~/.config/nvim
  rm -rf ~/.config/nvim/.git
  git clone https://github.com/2YY/astronvim_config ~/.config/nvim/lua/user
fi

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

# Git
if [ -n "$GIT_USER_NAME" ] && [ -n "$GIT_USER_EMAIL" ]; then
  git config --global user.name "$GIT_USER_NAME"
  git config --global user.email "$GIT_USER_EMAIL"
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


#!/bin/bash

function is_ubuntu() {
  if [ -f /etc/os-release ] && grep -qi 'ubuntu' /etc/os-release; then
    return 0
  else
    return 1
  fi
}

while getopts "n:e:" opt; do
  case $opt in
    n) GIT_USER_NAME="$OPTARG" ;;
    e) GIT_USER_EMAIL="$OPTARG" ;;
  esac
done

# 前回実行時に作成された一時ファイルが有れば削除しておきます。
command -v git &> /dev/null && git reset --hard HEAD && git clean -fd

# Ubuntu Homebrew Dependencies
if is_ubuntu; then
  sudo apt-get install -y build-essential procps curl file git checkinstall
fi

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
  if is_ubuntu; then
    (echo; echo 'eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"') >> "$HOME/.bashrc"
    eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"
    brew install gcc
  fi
fi
if is_ubuntu; then
  # lazygit
  LAZYGIT_VERSION=$(curl -s "https://api.github.com/repos/jesseduffield/lazygit/releases/latest" | \grep -Po '"tag_name": *"v\K[^"]*')
  curl -Lo lazygit.tar.gz "https://github.com/jesseduffield/lazygit/releases/download/v${LAZYGIT_VERSION}/lazygit_${LAZYGIT_VERSION}_Linux_x86_64.tar.gz"
  tar xf lazygit.tar.gz lazygit
  sudo install lazygit -D -t /usr/local/bin/

  # bat
  sudo apt install -y bat
  mkdir -p ~/.local/bin
  ln -s /usr/bin/batcat ~/.local/bin/bat

  # bottom
  curl -LO https://github.com/ClementTsang/bottom/releases/download/0.10.2/bottom_0.10.2-1_amd64.deb
  sudo dpkg -i bottom_0.10.2-1_amd64.deb

  # ffmpeg
  sudo apt install -y ffmpeg

  # fish
  sudo add-apt-repository ppa:fish-shell/release-3
  sudo apt update
  sudo apt install -y fish

  # fzf
  sudo apt install -y fzf

  # gdu
  add-apt-repository ppa:daniel-milde/gdu
  apt-get update
  apt-get install gdu

  # mise
  apt update -y && apt install -y gpg sudo wget curl
  sudo install -dm 755 /etc/apt/keyrings
  wget -qO - https://mise.jdx.dev/gpg-key.pub | gpg --dearmor | sudo tee /etc/apt/keyrings/mise-archive-keyring.gpg 1> /dev/null
  echo "deb [signed-by=/etc/apt/keyrings/mise-archive-keyring.gpg arch=amd64] https://mise.jdx.dev/deb stable main" | sudo tee /etc/apt/sources.list.d/mise.list
  sudo apt update
  sudo apt install -y mise

  # neovim
  curl -LO https://github.com/neovim/neovim/releases/latest/download/nvim.appimage
  chmod u+x nvim.appimage
  ./nvim.appimage
  mkdir -p /opt/nvim
  mv -f nvim.appimage /opt/nvim/nvim

  # ripgrep
  curl -LO https://github.com/BurntSushi/ripgrep/releases/download/14.1.0/ripgrep_14.1.0-1_amd64.deb
  sudo dpkg -i ripgrep_14.1.0-1_amd64.deb
else
  brew install jesseduffield/lazygit/lazygit
  brew install bat bottom ffmpeg fish fzf gdu mise neovim ripgrep
fi
brew bundle --global

# Alacritty
cp -f ./configs/alacritty.toml ~/.config/alacritty/alacritty.toml

# AstroNvim
if [ ! -d "$HOME/.config/nvim" ]; then
  # git clone https://github.com/AstroNvim/AstroNvim ~/.config/nvim
  git clone https://github.com/2YY/astronvim_config ~/.config/nvim
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
if ! grep -Fxq "$FISH_PATH" /etc/shells; then
    if ! grep -Fxq "$FISH_PATH" /etc/shells; then
      sudo sh -c "echo $FISH_PATH >> /etc/shells"
    fi
fi
# chsh -s "$FISH_PATH"
if ! contains_string "fish_greeting" "$HOME/.config/fish/config.fish"; then
  echo 'set fish_greeting' >> ~/.config/fish/config.fish
fi
if ! contains_string "accept-autosuggestion" "$HOME/.config/fish/config.fish"; then
  printf 'bind \\t accept-autosuggestion\n' >> "$HOME/.config/fish/config.fish"
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
  echo 'zoxide init fish | source' >> ~/.config/fish/config.fish
fi

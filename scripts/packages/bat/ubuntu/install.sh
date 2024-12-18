if is_ubuntu; then
  sudo apt install -y bat

  # NOTE: Ubuntu の場合、apt でインストールすると batcat というコマンド名になってしまうので、bat というコマンド名で使えるようにする。
  mkdir -p ~/.local/bin
  ln -s /usr/bin/batcat ~/.local/bin/bat
else
  brew install bat
fi

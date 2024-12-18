if is_ubuntu; then
  sudo apt remove -y bat

  # NOTE: インストール時に設定したシムリンクを削除しておく。
  rm ~/.local/bin/bat
else
  brew uninstall bat
fi

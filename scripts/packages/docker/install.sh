if is_ubuntu; then
  # NOTE: 動作のために /dev/kvm に対する権限が必要。権限が無ければ設定しておく。
  [ -r /dev/kvm ] && [ -w /dev/kvm ] || { 
    echo 'insufficient privileges'; 
    sudo usermod -a -G kvm "$USER"; 
  }
else
  brew install --cask rancher
fi

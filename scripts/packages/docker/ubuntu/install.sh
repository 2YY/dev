# NOTE: 動作のために /dev/kvm に対する権限が必要。権限が無ければ設定しておく。
# HACK: Docker のインストール時にしかこのグループを気にすることなさそうなので、ここでベタで処理してるが、他のパッケージにも影響が有る場合は、このグループへの追加自体もパッケージに切り出して依存関係を管理できるようにする。
[ -r /dev/kvm ] && [ -w /dev/kvm ] || {
  sudo usermod -a -G kvm "$USER";
}

# NOTE: Rancher Desktop のリポジトリを追加し、そこ経由で Rancher Desktop をインストール。
curl -s https://download.opensuse.org/repositories/isv:/Rancher:/stable/deb/Release.key | gpg --dearmor | sudo dd status=none of=/usr/share/keyrings/isv-rancher-stable-archive-keyring.gpg
echo 'deb [signed-by=/usr/share/keyrings/isv-rancher-stable-archive-keyring.gpg] https://download.opensuse.org/repositories/isv:/Rancher:/stable/deb/ ./' | sudo dd status=none of=/etc/apt/sources.list.d/isv-rancher-stable.list
sudo apt update
sudo apt install rancher-desktop

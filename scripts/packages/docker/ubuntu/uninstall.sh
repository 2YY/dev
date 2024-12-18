sudo apt remove rancher-desktop
sudo rm /etc/apt/sources.list.d/isv-rancher-stable.list
sudo rm /usr/share/keyrings/isv-rancher-stable-archive-keyring.gpg
sudo apt update

# NOTE: インストール時に追加されたグループから脱退しておく。
# HACK: `install.sh` から `kvm` グループへの追加処理自体が別パッケージに切り出された場合、ここも併せて修正。
sudo gpasswd -d "$USER" kvm

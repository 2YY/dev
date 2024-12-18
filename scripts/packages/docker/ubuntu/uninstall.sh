# HACK: `install.sh` から `kvm` グループへの追加処理自体が別パッケージに切り出された場合、ここも併せて修正。
sudo gpasswd -d "$USER" kvm

# Chocolatey
choco install packages.config

# Directories
New-Item -ItemType Directory -Path "$env:APPDATA\alacritty" -Force
New-Item -ItemType Directory -Path "$env:APPDATA\alacritty" -Force

# Alacritty
Copy-Item -Path .\alacritty.yml -Destination "$env:APPDATA\alacritty\alacritty.yml" -Force

# Dev Container CLI
npm install -g node-gyp @devcontainers/cli

# starship
Copy-Item -Path .\starship.toml -Destination "$env:USERPROFILE\.config\starship.toml" -Force
Add-Content -Path $PROFILE -Value 'Invoke-Expression (&starship init powershell)'

# zoxide
Add-Content -Path $PROFILE -Value 'Invoke-Expression (& { (zoxide init powershell | Out-String) })'

# TODO: `nvim.sh` のシムリンクを /usr/local/bin に作成し、`nvim` コマンドで実行できるようにする

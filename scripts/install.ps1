# Directories
if (-not (Test-Path -Path $env:APPDATA\alacritty)) { New-Item -ItemType Directory -Path $env:APPDATA\alacritty -Force | Out-Null }

# Options
$gitUserName = ""
$gitUserEmail = ""
for ($i = 0; $i -lt $args.Length; $i++) {
   switch ($args[$i]) {
     "-n" {
       $i++
       $gitUserName = $args[$i]
     }
     "-e" {
       $i++
       $gitUserEmail = $args[$i]
     }
   }
}

# Chocolatey
choco install ./configs/packages.config -y

# Alacritty
$alacrittyShellConfig = @"
shell:
  program: wsl
  args:
    - ~
    - -d
    - Ubuntu
"@
Move-Item -Path ".\configs\alacritty.toml" -Destination "$env:APPDATA\alacritty\alacritty.toml" -Force
Add-Content -Path "$env:APPDATA\alacritty\alacritty.toml" -Value $alacrittyShellConfig

# Git
if ($gitUserName -ne "" -and $gitUserEmail -ne "") {
  git config --global user.name $gitUserName
  git config --global user.email $gitUserEmail
}

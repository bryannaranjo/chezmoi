
Set-ExecutionPolicy Bypass -Scope Process -Force; [System.Net.ServicePointManager]::SecurityProtocol = [System.Net.ServicePointManager]::SecurityProtocol -bor 3072; iex ((New-Object System.Net.WebClient).DownloadString('https://community.chocolatey.org/install.ps1'))


choco install microsoft-windows-terminal nerd-fonts-firacode oh-my-posh -y
# or
# winget install -e --id Microsoft.WindowsTerminal JanDeDobbeleer.OhMyPosh DEVCOM.JetBrainsMonoNerdFont

# 1. Download Autosuggestions
git clone https://github.com/zsh-users/zsh-autosuggestions ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-autosuggestions

# 2. Download Syntax Highlighting
git clone https://github.com/zsh-users/zsh-syntax-highlighting.git ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-syntax-highlighting

#winget install ajeetdsouza.zoxide
#or
choco install zoxide -y

Install-Module -Name Terminal-Icons -Repository PSGallery -Force -Confirm:$false
Install-Module PSReadLine -Force -SkipPublisherCheck -AllowClobber


Set-ExecutionPolicy -ExecutionPolicy RemoteSigned -Scope LocalMachine
if (!(Test-Path $PROFILE)) { New-Item -Path $PROFILE -Type File -Force }

# powershell profile
@'

# 1. Initialize Oh My Posh
oh-my-posh init pwsh --config "$env:POSH_THEMES_PATH/atomicBit.omp.json" | Invoke-Expression

# 2. Initialize Zoxide (Better CD)
Invoke-Expression (& { (zoxide init powershell | Out-String) })

# 3. Enable Terminal Icons
Import-Module -Name Terminal-Icons

# 4. Enable Autosuggestions & Syntax Highlighting (PSReadLine)
Set-PSReadLineOption -PredictionSource History   # Enables "Ghost text" from history
Set-PSReadLineOption -PredictionViewStyle Inline # Options: Inline (Ghost text) or ListView (Menu)
Set-PSReadLineOption -EditMode Windows           # Ensures standard Ctrl+C/V shortcuts work

'@ | Out-File -FilePath $PROFILE -Encoding UTF8 -append

notepad $PROFILE


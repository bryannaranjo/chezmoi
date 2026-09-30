# 1. Initialize Oh My Posh
oh-my-posh init pwsh --config "$env:POSH_THEMES_PATH/wopian.omp.json" | Invoke-Expression
# oh-my-posh init pwsh --config "$env:POSH_THEMES_PATH/tokyonight_storm.omp.json" | Invoke-Expression
#wopian tokyonight_storm


# 2. Initialize Zoxide (Better CD)
Invoke-Expression (& { (zoxide init powershell | Out-String) })

# 3. Enable Terminal Icons
if ($PSVersionTable.PSVersion.Major -ge 7 ) {
    Import-Module Terminal-Icons
}

# 4. Enable Autosuggestions & Syntax Highlighting (PSReadLine)
Set-PSReadLineOption -PredictionSource History   # Enables "Ghost text" from history
Set-PSReadLineOption -PredictionViewStyle Inline # Options: Inline (Ghost text) or ListView (Menu)
Set-PSReadLineOption -EditMode Windows           # Ensures standard Ctrl+C/V shortcuts work

# Yazi function
function y {
    $tmp = (New-TemporaryFile).FullName
    yazi $args --cwd-file="$tmp"
    $cwd = Get-Content -Path $tmp -Encoding UTF8
    if (-not [String]::IsNullOrEmpty($cwd) -and $cwd -ne $PWD.Path) {
        Set-Location -LiteralPath (Resolve-Path -LiteralPath $cwd).Path
    }
    Remove-Item -Path $tmp
}


# Enhanced Listing
function la { Get-ChildItem | Format-Table -AutoSize }
function ll { Get-ChildItem -Force | Format-Table -AutoSize }

# Git Shortcuts
function gs { git status }

function ga { git add . }

Remove-Alias gc -Force
function gc { param($m) git commit -m "$m" }

function gpush { git push }

function gpull { git pull }

function g { __zoxide_z github }

function gcl { git clone "$args" }

function gcom {
    git add .
    git commit -m "$args"
}
function lazyg {
    git add .
    git commit -m "$args"
    git push
}

function ls { eza --icons --grid --long --all $args }
function tree { eza --icons -T -L2 }

#fastfetch
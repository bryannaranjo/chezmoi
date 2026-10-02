# Oh My Posh theme switcher. Dot-sourced from profile.ps1.
#
#   omp-next / omp-prev   cycle to the next / previous theme (this window only)
#   omp-set <name>        jump to a theme (Tab completes theme names)
#   omp-list              list all themes; * marks the current one
#   omp-random            try a random theme
#   omp-save              keep the current theme for new windows
#   omp-reset             go back to the saved (or default) theme
#
# Changes only affect the current window until you run omp-save.

$global:OmpDefault  = 'wopian'
$global:OmpSaveFile = Join-Path $HOME '.config/powershell/omp-theme.txt'

function Get-OmpThemeDir {
    $candidates = @($env:POSH_THEMES_PATH)
    if ($env:LOCALAPPDATA) { $candidates += Join-Path $env:LOCALAPPDATA 'Programs/oh-my-posh/themes' }
    foreach ($d in $candidates) { if ($d -and (Test-Path $d)) { return $d } }
}

function Get-OmpThemes {
    $dir = Get-OmpThemeDir
    if (-not $dir) { return @() }
    Get-ChildItem -Path $dir -Filter '*.omp.json' | Sort-Object Name |
        ForEach-Object { $_.Name -replace '\.omp\.json$', '' }
}

function Get-OmpSaved {
    if (Test-Path $global:OmpSaveFile) {
        $saved = (Get-Content $global:OmpSaveFile -TotalCount 1).Trim()
        if ($saved) { return $saved }
    }
    $global:OmpDefault
}

function Set-OmpTheme {
    param([Parameter(Mandatory)][string]$Name, [switch]$Quiet)
    if (-not $global:OmpThemes) { $global:OmpThemes = @(Get-OmpThemes) }
    $file = Join-Path (Get-OmpThemeDir) "$Name.omp.json"
    if (-not (Test-Path $file)) { Write-Warning "Theme '$Name' not found. Run omp-list to see the names."; return }
    oh-my-posh init pwsh --config $file | Invoke-Expression
    $global:OmpTheme = $Name
    $global:OmpIndex = [array]::IndexOf($global:OmpThemes, $Name)
    if (-not $Quiet) {
        Write-Host ("Theme {0}/{1}: {2}" -f ($global:OmpIndex + 1), $global:OmpThemes.Count, $Name) -ForegroundColor Cyan
    }
}

function Step-OmpTheme([int]$Step) {
    if (-not $global:OmpThemes) { $global:OmpThemes = @(Get-OmpThemes) }
    $n = $global:OmpThemes.Count
    if ($n -eq 0) { Write-Warning 'No Oh My Posh themes found.'; return }
    $i = ((($global:OmpIndex + $Step) % $n) + $n) % $n
    Set-OmpTheme $global:OmpThemes[$i]
}

function omp-next   { Step-OmpTheme 1 }
function omp-prev   { Step-OmpTheme -1 }
function omp-set    { param([Parameter(Mandatory)][string]$Name) Set-OmpTheme $Name }
function omp-random { if ($global:OmpThemes) { Set-OmpTheme (Get-Random -InputObject $global:OmpThemes) } }
function omp-reset  { Set-OmpTheme (Get-OmpSaved) }
function omp-list {
    $i = 0
    foreach ($t in $global:OmpThemes) {
        $i++
        $mark = if ($t -eq $global:OmpTheme) { '*' } else { ' ' }
        '{0} {1,3}  {2}' -f $mark, $i, $t
    }
}
function omp-save {
    if (-not $global:OmpTheme) { Write-Warning 'No theme is active.'; return }
    Set-Content -Path $global:OmpSaveFile -Value $global:OmpTheme
    Write-Host "Saved '$($global:OmpTheme)' as your theme for new windows." -ForegroundColor Green
}

Register-ArgumentCompleter -CommandName omp-set, Set-OmpTheme -ParameterName Name -ScriptBlock {
    param($cmd, $param, $word)
    $global:OmpThemes | Where-Object { $_ -like "$word*" }
}

# Start-up: load the saved theme (or the default).
if (Get-Command oh-my-posh -ErrorAction SilentlyContinue) {
    $global:OmpThemes = @(Get-OmpThemes)
    $global:OmpIndex  = 0
    $start = Get-OmpSaved
    if ($global:OmpThemes -contains $start)  { Set-OmpTheme $start -Quiet }
    elseif ($global:OmpThemes.Count -gt 0)   { Set-OmpTheme $global:OmpThemes[0] -Quiet }
    else                                     { oh-my-posh init pwsh | Invoke-Expression }
}

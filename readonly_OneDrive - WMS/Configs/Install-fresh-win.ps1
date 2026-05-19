# essentials

$Apps = @(
    "Microsoft.WindowsTerminal"
    "Nmap.Nmap"
    "WinSCP.WinSCP"
    "Microsoft.VisualStudioCode"
    "NerdFonts.FiraCode"
    "Microsoft.WSL"
    "JanDeDobbeleer.OhMyPosh"
    "Git.Git"
    "GitHub.cli"
    "GNU.Nano"
    "Microsoft.Sysinternals"
    "FlowLauncher.FlowLauncher"
    "Microsoft.PowerToys"
    "7zip.7zip"
    "twpayne.chezmoi"
    "LGUG2Z.Komorebi"
    "AmrDeveloper.Yasb"
)

foreach ($App in $Apps) {
    winget install --id $App --accept-package-agreements --accept-source-agreements
}



# optional
$Apps = @(
    # Core Dev, Editors & Systems
    "Notepad++.Notepad++"
    "SimonTatham.PuTTY"
    "Google.Chrome"
    "Microsoft.WSL"
    "GitHub.cli"
    "Microsoft.Office"
    "Mozilla.Firefox"
    "KeePassXITeam.KeePassXC"   # Modern cross-platform KeePass fork
    "GitHub.GitHubDesktop"
    "Oracle.VirtualBox"
    "GlebBruchiy.UNetbootin"
    "Axosoft.GitKraken"
    "Docker.DockerDesktop"
    
    # Utilities & Workspace Search
    "VOIDtools.Everything"
    
    # UI Customization & Tiling Shell Extensions
    "TranslucentTB.TranslucentTB"
    "Windhawk.Windhawk"
    "Rockdanister.LivelyWallpaper"
    "Rainmeter.Rainmeter"
    "Eythaann.SeelenUI"
    "FilesCommunity.Files"
    "BeXCool.BeWidgets"
    
    # Network / Access
    "Twingate.TwingateClient"
)

# Run the Winget loop for standard installers
foreach ($App in $Apps) {
    winget install --id $App --accept-package-agreements --accept-source-agreements
}


## thide
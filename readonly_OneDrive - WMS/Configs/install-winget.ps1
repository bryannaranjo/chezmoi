
# Ensure script runs as Administrator
if (-not ([Security.Principal.WindowsPrincipal] [Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole] "Administrator")) {
    Write-Host "Please run this script as Administrator." -ForegroundColor Red
    exit
}

# Set download URLs for dependencies and Winget
$wingetUrl = "https://github.com/microsoft/winget-cli/releases/latest/download/Microsoft.DesktopAppInstaller_8wekyb3d8bbwe.msixbundle"
$vclibsUrl = "https://aka.ms/Microsoft.VCLibs.x64.14.00.Desktop.appx"
$uiXamlUrl = "https://github.com/microsoft/microsoft-ui-xaml/releases/latest/download/Microsoft.UI.Xaml.2.8.appx"

# Create temp folder
$tempPath = "$env:TEMP\WingetInstall"
New-Item -ItemType Directory -Path $tempPath -Force | Out-Null

# Download files
Invoke-WebRequest -Uri $wingetUrl -OutFile "$tempPath\AppInstaller.msixbundle"
Invoke-WebRequest -Uri $vclibsUrl -OutFile "$tempPath\VCLibs.appx"
Invoke-WebRequest -Uri $uiXamlUrl -OutFile "$tempPath\UIXaml.appx"

# Install dependencies
Add-AppxPackage -Path "$tempPath\VCLibs.appx"
Add-AppxPackage -Path "$tempPath\UIXaml.appx"

# Install Winget
Add-AppxPackage -Path "$tempPath\AppInstaller.msixbundle"

# Verify installation
winget --version

# Command to terms
Add-AppPackage -path "https://cdn.winget.microsoft.com/cache/source.msix."
winget upgrade --accept-source-agreements

# Install Foxit
C:\"Program Files"\WindowsApps\Microsoft.DesktopAppInstaller_1.17.10691.0_x64__8wekyb3d8bbwe\winget.exe install --scope machine Foxit.FoxitReader --silent

# Install 7Zip
C:\"Program Files"\WindowsApps\Microsoft.DesktopAppInstaller_1.17.10691.0_x64__8wekyb3d8bbwe\winget.exe install --scope machine 7zip.7zip --silent

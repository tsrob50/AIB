# Command to terms
Add-AppPackage -path "https://cdn.winget.microsoft.com/cache/source.msix."
winget upgrade --accept-source-agreements

# Install Foxit
winget install Foxit.FoxitReader --silent

# Install 7Zip
winget install 7zip.7zip --silent
# Azure Image Builder Portal Integration Inline Commands

# Inline command to download and extract AZCopy
New-Item -Type Directory -Path 'c:\\' -Name ImageBuilder,
invoke-webrequest -uri 'https://aka.ms/downloadazcopy-v10-windows' -OutFile 'c:\\ImageBuilder\\azcopy.zip',
Expand-Archive 'c:\\ImageBuilder\\azcopy.zip' 'c:\\ImageBuilder',
copy-item 'C:\\ImageBuilder\\azcopy_windows_amd64_*\\azcopy.exe\\' -Destination 'c:\\ImageBuilder'

# Inline command that uses AZCopy to download the archive file and extract to the ImageBuilder directory
# Use the SAS URL for the <ArchiveSource>
c:\\ImageBuilder\\azcopy.exe copy '<ArchiveSource>' c:\\ImageBuilder\\software.zip,
Expand-Archive 'c:\\ImageBuilder\\software.zip' c:\\ImageBuilder

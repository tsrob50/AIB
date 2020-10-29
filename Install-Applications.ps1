# Software install Script
#
# Applications to install:
#
# Foxit Reader Enterprise Packaging (requires registration)
# https://kb.foxitsoftware.com/hc/en-us/articles/360040658811-Where-to-download-Foxit-Reader-with-Enterprise-Packaging-MSI-
# 
# Notepad++
# https://notepad-plus-plus.org/downloads/v7.8.8/
# See comments on creating a custom setting to disable auto update message
# https://community.notepad-plus-plus.org/post/38160



#region Set logging 
$logFile = "c:\temp\" + (get-date -format 'yyyyMMdd') + '_softwareinstall.log'
function Write-Log {
    Param($message)
    Write-Output "$(get-date -format 'yyyyMMdd HH:mm:ss') $message" | Out-File -Encoding utf8 $logFile -Append
}
#endregion

#region Foxit Reader
try {
    Start-Process -filepath msiexec.exe -Wait -ErrorAction Stop -ArgumentList '/i', 'c:\temp\FoxitReader101_enu_Setup.msi', '/quiet', 'ADDLOCAL="FX_PDFVIEWER"'
    if (Test-Path "C:\Program Files (x86)\Foxit Software\Foxit Reader\FoxitReader.exe") {
        Write-Log "Foxit Reader has been installed"
    }
    else {
        write-log "Error locating the Foxit Reader executable"
    }
}
catch {
    $ErrorMessage = $_.Exception.message
    write-log "Error installing Foxit Reader: $ErrorMessage"
}
#endregion

#region Notepad++
try {
    Start-Process -filepath 'c:\temp\npp.7.8.8.Installer.x64.exe' -Wait -ErrorAction Stop -ArgumentList '/S'
    Copy-Item 'C:\temp\config.model.xml' 'C:\Program Files\Notepad++'
    Rename-Item 'C:\Program Files\Notepad++\updater' 'C:\Program Files\Notepad++\updaterOld'
    if (Test-Path "C:\Program Files\Notepad++\notepad++.exe") {
        Write-Log "Notepad++ has been installed"
    }
    else {
        write-log "Error locating the Notepad++ executable"
    }
}
catch {
    $ErrorMessage = $_.Exception.message
    write-log "Error installing Notepad++: $ErrorMessage"
}
#endregion


write-host "========= Removing publishsettings from Desktop (if any)...   ========="
[string] $desktopFolder = [Environment]::GetFolderPath("Desktop")
$removeSettings = "$desktopFolder\*.publishsettings"
Remove-Item $removeSettings -Force
write-host "Removing publishsettings Done!"
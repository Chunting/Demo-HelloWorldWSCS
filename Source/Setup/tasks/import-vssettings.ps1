Param([string] $vsSettingsFile)

write-host "========= Importing VS settings... ========="
Import-VSSettings $vsSettingsFile
Start-Sleep -s 10
Close-VS -Force
Start-Sleep -s 2
write-host "Importing VS settings done!"
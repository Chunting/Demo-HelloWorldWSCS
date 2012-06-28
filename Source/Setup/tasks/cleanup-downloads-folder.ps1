write-host "========= Cleaning up Downloads Folder... ========="
[string] $downloadsFolder = "~\Downloads"
if (-NOT (test-path "$downloadsFolder"))
{
    $downloadsFolder = (gp "hkcu:\Software\Microsoft\Windows\CurrentVersion\Explorer\Shell Folders" -Name "{374DE290-123F-4565-9164-39C4925E467B}")."{374DE290-123F-4565-9164-39C4925E467B}"
}
Remove-Item "$downloadsFolder\*" -recurse -force
write-host "Cleaning up Downloads Folder Done!"
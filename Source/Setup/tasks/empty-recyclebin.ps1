write-host "========= Emptying recycle bin...  ========="
$objShell = New-Object -ComObject Shell.Application
$objFolder = $objShell.Namespace(0xA) 
#Empty Recycle Bin
$objFolder.items() | %{ remove-item $_.path -Recurse -Confirm:$false}
write-host "Emptying recycle bin Done!"
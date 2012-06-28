write-host "========= Resetting Azure Compute Emulator & Dev Storage...  ========="
$CSRunFile = "C:\Program Files\Microsoft SDKs\Windows Azure\Emulator\csrun.exe"
$DSInitFile = "C:\Program Files\Microsoft SDKs\Windows Azure\Emulator\devstore\DSInit.exe"
& $CSRunFile @("/devfabric:start")
& $CSRunFile @("/devstore:start")
& $CSRunFile @("/devstore:shutdown")
& $CSRunFile @("/devfabric:shutdown")
Start-Process $DSInitFile @("/ForceCreate", "/silent") -Wait
& $CSRunFile @("/devfabric:shutdown")
& $CSRunFile @("/devfabric:clean")
& $CSRunFile @("/devfabric:start")
& $CSRunFile @("/devstore:start")
& $CSRunFile @("/removeAll")
write-host "Resetting Azure Comoute Emulator & Dev Storage Done!"
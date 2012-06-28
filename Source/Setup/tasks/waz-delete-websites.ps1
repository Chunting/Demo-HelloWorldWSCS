Param([string] $azureNodeSDKDir,
	[string] $webSitesToKeep)

write-host "========= Deleting all Windows Azure Web Sites... ========="
if($azureNodeSDKDir) {
	$azureCmd = (Join-Path $azureNodeSDKDir "node.exe") + " " + (Join-Path $azureNodeSDKDir "bin\azure")
	}
else {
	$azureCmd = "azure"
	}

[array] $keepList = $webSitesToKeep.Split(",") | % { $_.Trim() }
[regex]::matches((Invoke-Expression "$azureCmd site list"), "data:\s+(\S+)\s+([^-\s]+)") | Where { $keepList -notcontains $_.Groups[1].value -and $_.Groups[2].value -ne "State" } | foreach-object { Invoke-Expression ("$azureCmd site delete -q " + $_.Groups[1].value) }
write-host "Deleting all Windows Azure Web Sites done!"	

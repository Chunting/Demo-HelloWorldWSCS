Param([string] $configFile)

$scriptDir = (split-path $myinvocation.mycommand.path -parent)
Set-Location $scriptDir

# "========= Initialization =========" #
if($configFile -eq $nul -or $configFile -eq "")
{
	$configFile = "reset.local.xml"
}

# Get the key and account setting from configuration using namespace
[xml]$xml = Get-Content $configFile

[string] $workingDir = $xml.configuration.localPaths.workingDir

# "========= Main Script =========" #
write-host "========= Create working directory... ========="
if (!(Test-Path "$workingDir"))
{
	New-Item "$workingDir" -type directory | Out-Null
}
write-host "Creating working directory done!"

write-host "========= Install Node Package ... ========="
& "npm install azure -g"
write-host "========= Installing Node Package done! ... ========="
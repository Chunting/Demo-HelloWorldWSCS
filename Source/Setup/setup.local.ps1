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

[string] $demoWorkingDir = $xml.configuration.localPaths.demoWorkingDir

# "========= Main Script =========" #
write-host "========= Create working directory... ========="
if (!(Test-Path "$demoWorkingDir"))
{
	New-Item "$demoWorkingDir" -type directory | Out-Null
}
write-host "Creating working directory done!"

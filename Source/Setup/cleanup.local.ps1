Param([string] $configFile)

$scriptDir = (split-path $myinvocation.mycommand.path -parent)
Set-Location $scriptDir

if ((Get-PSSnapin -Registered | ?{$_.Name -eq "DemoToolkitSnapin"}) -eq $null) {
	Write-Host "Demo Toolkit Snapin not installed." -ForegroundColor Red
	Write-Host "Install it from https://github.com/microsoft-dpe/demo-tools/downloads" -ForegroundColor Red
	return;
} 
if ((Get-PSSnapin | ?{$_.Name -eq "DemoToolkitSnapin"}) -eq $null) {
	Add-PSSnapin DemoToolkitSnapin	
} 

# "========= Initialization =========" #
if($configFile -eq $nul -or $configFile -eq "")
{
	$configFile = "reset.local.xml"
}

# Get the key and account setting from configuration using namespace
[xml]$xml = Get-Content $configFile

[string] $demoWorkingDir = $xml.configuration.localPaths.demoWorkingDir

# "========= Main Script =========" #
#========= Removing current working directory... =========
& ".\tasks\remove-workingdir.ps1" -demoWorkingDir $demoWorkingDir


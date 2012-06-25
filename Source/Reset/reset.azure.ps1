Param([string] $configFile)

$scriptDir = (split-path $myinvocation.mycommand.path -parent)
Set-Location $scriptDir

if ((Get-PSSnapin -Registered | ?{$_.Name -eq "DemoToolkitSnapin"}) -eq $null) {
	Write-Host "Demo Toolkit Snapin not installed." -ForegroundColor Red
	Write-Host "Install it from https://github.com/microsoft-dpe/demo-tools/tree/master/demo-toolkit/bin" -ForegroundColor Red
	return;
} 
if ((Get-PSSnapin | ?{$_.Name -eq "DemoToolkitSnapin"}) -eq $null) {
	Add-PSSnapin DemoToolkitSnapin	
} 

# "========= Initialization =========" #
pushd ".."
if($configFile -eq $nul -or $configFile -eq "")
{
	$configFile = "reset.azure.xml"
}

# Get the key and account setting from configuration using namespace
[xml]$xml = Get-Content $configFile
[string] $connectionString = $xml.configuration.sb.connectionString

popd

# "========= Main Script =========" #

#load the storage client in order to do our operations
$sblib = Resolve-Path "../../assets/sblibs/Microsoft.ServiceBus.dll"
& ".\reset-azure-queue.ps1" -sblib $sblib -connectionString $connectionString -queue "demomessages"
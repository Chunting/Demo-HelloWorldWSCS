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
if($configFile -eq $nul -or $configFile -eq "")
{
	$configFile = "reset.azure.xml"
}

# Get the key and account setting from configuration using namespace
[xml]$xml = Get-Content $configFile
[string] $wazPublishSettings = $xml.configuration.windowsAzureSubscription.publishSettingsFile
[string] $webSitesToKeep = $xml.configuration.windowsAzureSubscription.webSitesToKeep
[string] $publishProfileDownloadUrl =  $xml.configuration.urls.publishProfileDownloadUrl

[string] $azureLocation = $xml.configuration.windowsAzureSubscription.Location
[string] $azureServiceName = $xml.configuration.windowsAzureSubscription.azureServiceName
[string] $azureFolder = $xml.configuration.windowsAzureSubscription.azureFolder
[string] $azurePackageFileName = $xml.configuration.windowsAzureSubscription.azurePackageFileName
[string] $azureConfigurationFile = $xml.configuration.windowsAzureSubscription.azureConfigurationFile
[string] $publishProfileDownloadUrl = $xml.configuration.urls.publishProfileDownloadUrl

# "========= Main Script =========" #
if ($wazPublishSettings -eq "" -or $wazPublishSettings -eq $nul) {
    write-host "you need to specify the publish setting profile. After downloading the publish settings profile from the management portal, specify the file location in the configuration file path under the publishSettingsFile element."
    start $publishProfileDownloadUrl
    return
}

$title = "Delete Web Sites"
$message = "This script will remove all the Windows Azure Web Sites from your subscription and will Deploy a Cloud Service named '$azureServiceName' (first removing the existing one.) Are you sure you want to continue?"
$yes = New-Object System.Management.Automation.Host.ChoiceDescription "&Yes"
$no = New-Object System.Management.Automation.Host.ChoiceDescription "&No"
$options = [System.Management.Automation.Host.ChoiceDescription[]]($yes, $no)
$confirmation = $host.ui.PromptForChoice($title, $message, $options, 0)     

if($confirmation -eq 0) {

#========= Importing the Windows Azure Subscription Settings File... =========
& ".\tasks\import-waz-publishsettings.ps1" -wazPublishSettings $wazPublishSettings

#========= Deleting all Windows Azure Web Sites... =========
& ".\tasks\waz-delete-websites.ps1" -webSitesToKeep $webSitesToKeep

#========= Deploy Cloud Service... =========================
& ".\tasks\waz-deploy-cloud-service.ps1" -wazPublishSettings $wazPublishSettings -azureLocation $azureLocation -MeetAzureServiceName $MeetAzureServiceName -MeetAzureFolder $MeetAzureFolder -MeetAzurePackageFileName  $MeetAzurePackageFileName -MeetAzureConfigurationFile $MeetAzureConfigurationFile -publishProfileDownloadUrl $publishProfileDownloadUrl

} #### if(confirmation)


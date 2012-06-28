Param([string] $wazPublishSettings,
	[string] $azureLocation,
	[string] $MeetAzureServiceName,
	[string] $MeetAzureFolder,
	[string] $MeetAzurePackageFileName,
	[string] $MeetAzureConfigurationFile,
	[string] $publishProfileDownloadUrl)
	
# -----------------------------------------------------------------------------------------------------
# Support functions
# -----------------------------------------------------------------------------------------------------
function ensureDeployment ($serviceName, $slot, $packageFile, $configurationFile, $label)
{
	if (-not (Get-AzureService $serviceName)){
		New-AzureService -ServiceName $serviceName -Location $azureLocation | out-null
	}
	
	$title = "Upload the certificate"
	$message = "Before continuing with the setup please upload the cert.pfx from the assets\MeetAzurePackage folder to the Meet Azure hosted service."
	$ok = New-Object System.Management.Automation.Host.ChoiceDescription "&OK"
	$options = [System.Management.Automation.Host.ChoiceDescription[]]($ok)
	$confirmation = $host.ui.PromptForChoice($title, $message, $options, 0)
	
	$deployment = Get-AzureDeployment -ServiceName $serviceName -Slot $slot;

	if ($deployment.Name -ne $null) 
	{
		Write-Output 'Deployment already exists. Deleting ...';
		Remove-AzureDeployment -ServiceName $serviceName -Slot $slot -Force | out-null
	}
	
	New-AzureDeployment -ServiceName $serviceName -Slot $slot -Package $packageFile -Configuration $configurationFile -Label $label
	
	Write-Output 'Deployment created. Starting...';
	
	Get-AzureService $serviceName | 
		Get-AzureDeployment -Slot $slot | 
		Set-AzureDeployment -Status -NewStatus 'Running'
}

function ensureProjectDeployment ($serviceName, $path, $packageFileName, $configurationFile, $slot )
{
	# -----------------------------------------------------------------------------------------------------
	$text = 'Creating deployment for ' + $serviceName + ' if not exists...'
	Write-Output $text;
	$packagePath = Join-Path $path $packageFileName;
	$configurationFilePath = Join-Path $path $configurationFile;
	$deploymentLabel = $serviceName + ' - ' + (Get-Date -Format 'yyyy-MM-dd HH:mm:ss');

	ensureDeployment $serviceName $slot $packagePath $configurationFilePath $deploymentLabel
}

# -----------------------------------------------------------------------------------------------------
# Script
# -----------------------------------------------------------------------------------------------------
$ensureDeployments = @(
	@{
		"Slot" = 'production';
	},
    @{
		"Slot" = 'staging';
	}
)

# "========= Main Script =========" #
if ($wazPublishSettings -eq "" -or $wazPublishSettings -eq $nul) {
	write-host "you need to specify the publish setting profile. After downloading the publish settings profile from the management portal, specify the file location in the configuration file path under the publishSettingsFile element."
	start $publishProfileDownloadUrl
	return
}

 if ($wazPublishSettings -ne "" -and $wazPublishSettings -ne $nul) {
	write-host "========= Importing the Windows Azure Management Module... ========="
	# Ensure that we are loading the Azure module from the correct folder
	Remove-Module Microsoft.WindowsAzure.ManagementTools.PowerShell.ServiceManagement -ErrorAction SilentlyContinue
	Import-Module .\assets\WindowsAzureCmdLets\Microsoft.WindowsAzure.ManagementTools.PowerShell.ServiceManagement
	Remove-Module Microsoft.WindowsAzure.ManagementTools.PowerShell.Storage -ErrorAction SilentlyContinue
	Import-Module .\assets\WindowsAzureCmdLets\Microsoft.WindowsAzure.ManagementTools.PowerShell.Storage

	write-host "========= Importing the Windows Azure Subscription Settings File... ========="
	$wazPublishSettings = Resolve-Path $wazPublishSettings
	Import-AzureSubscription $wazPublishSettings
	write-host "Importing the Windows Azure Subscription Settings File done!"

	write-host "========= Ensuring Project Deployment ... ========="
	foreach ($deploy in $ensureDeployments){
		write-host "========= Ensuring Storage Service... ========="
		if (-not (Get-AzureStorageAccount $azureServiceName))
		{
			# Create Storage Service
			New-AzureStorageAccount -ServiceName $azureServiceName -Location $azureLocation | out-null
			write-host "Storage Service created!"
		}
		else
		{
			write-host "Storage Service already exists!"
		}
		Get-AzureSubscription | Set-AzureSubscription -CurrentStorageAccount $azureServiceName
		
		ensureProjectDeployment $azureServiceName (Resolve-Path $azureFolder) $azurePackageFileName $azureConfigurationFile $deploy["Slot"]
	}
}
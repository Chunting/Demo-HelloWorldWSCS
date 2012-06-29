Param([string] $wazPublishSettings,
	[string] $azureServiceName)
	
$ensureDeployments = @(
	@{
		"Slot" = 'production';
	},
    @{
		"Slot" = 'staging';
	}
)

# "========= Main Script =========" #
write-host "========= Delete Cloud Service...  ========= "	

write-host "========= Importing the Windows Azure Management Module... ========="
# Ensure that we are loading the Azure module from the correct folder
Remove-Module Microsoft.WindowsAzure.ManagementTools.PowerShell.ServiceManagement -ErrorAction SilentlyContinue
Import-Module .\assets\WindowsAzureCmdLets\Microsoft.WindowsAzure.ManagementTools.PowerShell.ServiceManagement

write-host "========= Importing the Windows Azure Subscription Settings File... ========="
$wazPublishSettings = Resolve-Path $wazPublishSettings
Import-AzureSubscription $wazPublishSettings
write-host "Importing the Windows Azure Subscription Settings File done!"

write-host "========= Removing all cloud service deployments ... ========="
foreach ($deploy in $ensureDeployments){
	write-host "========= Remove Cloud Service $deploy["Slot"] deployment... ========="
	if (Get-AzureStorageAccount $azureServiceName)
	{
		# Create Storage Service
		Remove-AzureDeployment -ServiceName $azureServiceName -Slot $deploy["Slot"] -Force | out-null
		write-host "Cloud Service removed!"
	}
}
write-host "========= Removed all cloud service deployments ... ========="
$svc = Get-AzureService -ServiceName $azureServiceName
$svc
if(($svc))
{
	Remove-AzureService -ServiceName $azureServiceName | out-null
}

write-host "========= Deleting Cloud Service done! ========= "	
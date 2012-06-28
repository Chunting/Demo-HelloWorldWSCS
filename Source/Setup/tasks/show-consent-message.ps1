param([switch]$ResetAzure,[switch]$ResetLocal,[switch]$SetupAzure,[switch]$SetupLocal,[switch]$CleanupLocal,[switch]$CleanupAzure)

if ($SetupLocal.IsPresent) {
    Write-Warning "This script will setup your local machine by performing the following tasks:"
    Write-Host ""    
    Write-Host "1. Create the demo's working directory"
	

if ($ResetLocal.IsPresent) {
    Write-Warning "This script will reset your local machine by performing the following tasks:"
    Write-Host ""
    Write-Host " 1. Close all Visual Studio instances"
    Write-Host " 2. Close all Internet Explorer instances"
    Write-Host " 3. Clear Internet Explorer History" -ForegroundColor Red
	Write-Host " 4. Clear Internet Explorer Cookies" -ForegroundColor Red
	Write-Host " 5. Clear Internet Explorer Form Data" -ForegroundColor Red    
    Write-Host " 6. Clear Internet Explorer AutoComplete Settings" -ForegroundColor Red
	Write-Host " 7. Reset the Visual Studio settings" -ForegroundColor Red
    Write-Host " 8. Remove Visual Studio most recently used projects"
	Write-Host " 9. Remove Visual Studio most recently used files"
    Write-Host "10. Clean up Downloads Folder" -ForegroundColor Red
	Write-Host "11. Remove local Windows Azure subscription settings from Visual Studio"
    Write-Host "12. Remove publishsettings from Desktop (if any)" -ForegroundColor Red
    Write-Host "13. Restart the Windows Azure Compute Emulator & Dev Storage"
    Write-Host "14. Set Visual Studio New Project Dialog Defaults"
	Write-Host "15. Set Visual Studio Open Project Dialogs Defaults"
    Write-Host "16. Reset the demo solutions from the working directory"
    Write-Host "17. Launch a new Visual Studio instance"
    Write-Host "18. Launch Windows Azure management portal in Intenet Explorer"
}

if ($SetupAzure.IsPresent) {
    Write-Host "This demo does not require any setup step in Windows Azure" -ForegroundColor Green
    Write-Host ""
}

if ($ResetAzure.IsPresent) {
    Write-Warning "This script will reset your Azure subscription by performing the following tasks:"
    Write-Host ""
    Write-Host " 1. Delete Websites configured in the Setup.Azure.xml file" -ForegroundColor Red
    Write-Host " 2. Delete Cloud Services configured in the Setup.Azure.xml file" -ForegroundColor Red
}

if ($CleanupLocal.IsPresent) {
Write-Warning "This script will cleanup your local machine by performing the following tasks:"
    Write-Host ""
    Write-Host "1. Remove the working directory for the demo"
}

if ($CleanupAzure.IsPresent) {
    Write-Warning "This script will reset your Azure subscription by performing the following tasks:"
    Write-Host ""
    Write-Host " 1. Delete Websites configured in the Setup.Azure.xml file" -ForegroundColor Red
    Write-Host " 2. Delete Cloud Services configured in the Setup.Azure.xml file" -ForegroundColor Red
}

Write-Host ""

$title = ""
$message = "Are you sure you want to continue?"

$yes = New-Object System.Management.Automation.Host.ChoiceDescription "&Yes"
$no = New-Object System.Management.Automation.Host.ChoiceDescription "&No"
$options = [System.Management.Automation.Host.ChoiceDescription[]]($yes, $no)
$confirmation = $host.ui.PromptForChoice($title, $message, $options, 1)

if ($confirmation -eq 0) {
    exit 0
}
else {
    exit 1
}



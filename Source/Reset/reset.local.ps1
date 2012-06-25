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
pushd ".."
if($configFile -eq $nul -or $configFile -eq "")
{
	$configFile = "reset.local.xml"
}

# Get the key and account setting from configuration using namespace
[xml]$xml = Get-Content $configFile

[string] $demoWorkingDir = $xml.configuration.localPaths.demoWorkingDir
[string] $cachingBeginSolutionDir = $xml.configuration.localPaths.cachingBeginSolutionDir
[string] $sbrelayBeginSolutionDir = $xml.configuration.localPaths.sbrelayBeginSolutionDir
[string] $publishProfilesDir = $xml.configuration.localPaths.publishProfilesDir
[string] $vsSettingsFile = $xml.configuration.localPaths.vsSettingsFile
[string] $sbOnPremiseSolution = $xml.configuration.localPaths.sbOnPremiseSolution
[string] $sbCloudSolution = $xml.configuration.localPaths.sbCloudSolution
[string] $CSharpSnippets = $xml.configuration.codeSnippets.cSharp

[string] $nugetSourceName = $xml.configuration.nuget.sourceName
[string] $nugetSourcePath = $xml.configuration.nuget.sourcePath

[string] $windowsAzureMgmtPortal = $xml.configuration.urls.windowsAzureMgmtPortal
[string] $windowsAzurePortal = $xml.configuration.urls.windowsAzurePortal

$cachingBeginSolutionDir = Resolve-Path $cachingBeginSolutionDir
$sbrelayBeginSolutionDir = Resolve-Path $sbrelayBeginSolutionDir
$publishProfilesDir = Resolve-Path $publishProfilesDir
$CSharpSnippets = Resolve-Path $CSharpSnippets
$vsSettingsFile = Resolve-Path $vsSettingsFile
$sbOnPremiseSolution = Join-Path $demoWorkingDir $sbOnPremiseSolution
$sbCloudSolution = Join-Path $demoWorkingDir $sbCloudSolution

# "========= Main Script =========" #

write-host "========= Closing Visual Studio... ========="
Close-VS -Force
Start-Sleep -s 2
write-host "Closing Visual Studio Done!"

write-host "========= Closing IE... ========="
Close-IE -Force
Start-Sleep -s 2
write-host "Closing IE Done!"

write-host "========= Clearing IE History ========="
Clear-IEFormData -ClearStoredPasswords
Clear-IEHistory
Clear-IECookies
write-host "Clearing IE History Done!"

write-host "========= Set IE AutoComplete Settings ========="
Set-SetIEAutoCompleteSettings -AutoCompleteForms  $false -AutoCompleteUsernamesAndPasswords $false -AskBeforeSavingPasswords $false
write-host "Set IE AutoComplete Settings Done!"

#========= Importing VS settings... =========
& ".\tasks\import-vssettings.ps1" -vsSettingsFile $vsSettingsFile

write-host "========= Removing VS most recently used projects... ========="
Clear-VSProjectMRUList
Clear-VSFileMRUList
write-host "Removing VS most recently used projects done!"

#========= Removing current working directory... =========
& ".\tasks\remove-workingdir.ps1"

#========= Cleaning up Downloads Folder... =========
& ".\tasks\cleanup-downloads-folder.ps1"

#======== Removing local Windows Azure subscription settings from VS... ========
& ".\tasks\remove-azure-vssettings.ps1"

#========= Removing publishsettings from Desktop (if any)...   =========
& ".\tasks\remove-desktop-publishsettings.ps1"

#========= Resetting Azure Compute Emulator & Dev Storage...  =========
& ".\tasks\reset-azure-compute-emulator.ps1"

write-host "========= Setting VS New Project Dialog Defaults... ========="
Set-VSNewProjectDialogDefaults -FxVersion 4.0 -TemplateName 'ASP.NET MVC 4 Web Application' -TemplateNode 'Templates\Visual C#\Web' -Path "$demoWorkingDir"
write-host "Setting VS New Project Dialog Defaults done!"

write-host "========= Setting VS Open Project Dialog Defaults... ========="
Set-VSOpenProjectDialogDefaults -Location "$demoWorkingDir" -All
write-host "Setting VS Open Project Dialog Defaults done!"

write-host "========= Copying Begin solution to working directory... ========="
# Caching
Copy-Item "$cachingBeginSolutionDir" "$demoWorkingDir" -recurse -Force
# SBRelay
Copy-Item "$sbrelayBeginSolutionDir" "$demoWorkingDir" -recurse -Force
write-host "Copying Begin solution to working directory done!"

# ========= Installing Code Snippets ... =========
& ".\install-code-snippets.ps1" -CSharpSnippets $CSharpSnippets

write-host "========= Creating Link in Windows Explorer Favories... ========="
Add-WindowsExplorerFavorite "CSPublishProfiles" $publishProfilesDir
write-host "Creating Link in Windows Explorer Favories done!"

write-host "========= Adding a new Package Nuget source... ========="
Add-NugetSource "$nugetSourceName" "$nugetSourcePath" -Force
write-host "Adding a new Package Nuget source done!"

write-host "========= Launching IE ========="
Start-IE "$windowsAzurePortal,$windowsAzureMgmtPortal"
write-host "Launching IE Done!"

write-host "========= Starting Visual Studio... ========="
Start-VS 
Start-Sleep -s 2
write-host "Starting Visual Studio Done!"

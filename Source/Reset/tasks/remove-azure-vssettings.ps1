write-host "======== Removing local Windows Azure subscription settings from VS... ========"
[string] $documentsFolder = [Environment]::GetFolderPath("MyDocuments")
$azureSettingsFile = Join-Path $documentsFolder "Visual Studio 2012\Settings\Windows Azure Connections.xml"
if (Test-Path $azureSettingsFile)
{
    Remove-Item $azureSettingsFile
}
write-host "Removing local Windows Azure subscription settings from VS Done!"
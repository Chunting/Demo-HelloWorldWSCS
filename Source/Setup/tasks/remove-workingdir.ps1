Param([string] $demoWorkingDir)

write-host "========= Removing current working directory... ========="
if (Test-Path "$demoWorkingDir")
{
	Remove-Item "$demoWorkingDir" -recurse -force
}
New-Item "$demoWorkingDir" -type directory
write-host "Removing current working directory done!"
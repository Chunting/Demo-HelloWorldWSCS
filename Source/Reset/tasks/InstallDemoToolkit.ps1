Param([string] $demoToolkitFolderPath )

###################
#    Functions    #
###################

function MoveFileContents ([string] $sourceFilePath, [string] $destinationFilePath )
{
       [byte[]] $bytes = [System.IO.File]::ReadAllBytes( $(resolve-path $sourceFilePath) )
       [System.IO.File]::WriteAllBytes($destinationFilePath, $bytes)
}

function UnblockFile([string] $filePath)
{
    $filePath = Resolve-Path $filePath
    $bakFilePath = $filePath + ".bak"
    Rename-Item $filePath $bakFilePath 
    MoveFileContents $bakFilePath $filePath   
    Remove-Item $bakFilePath
}

function DownloadFile([string] $filePath)
{	
	$url = "http://go.microsoft.com/fwlink/?LinkId=255267"
    
	$webclient = New-Object System.Net.WebClient 
    
    try 
    {       
        $webclient.DownloadFile($url, $filePath)
    }        
    catch [System.Net.WebException]
    {
        if(Test-Path $filePath)
        {
            rem $filePath
        }
        
        write-error "An error has occurred downloading the Demo Toolkit files."
        exit
    }
}

function Unzip([string] $filePath, [string] $outputPath)
{
	$shell_app = new-object -com shell.application 
	$zip_file = $shell_app.namespace($filePath) 
	$destination = $shell_app.namespace($outputPath) 
	$destination.Copyhere($zip_file.items())
}

#####################
#    Main script    #
#####################

$scriptDir = (Split-Path $myinvocation.mycommand.path -parent)
Set-Location $scriptDir

# Check if the DemoToolkit Folder already exists
if(-NOT (Test-Path $demoToolkitFolderPath))
{
	New-Item $demoToolkitFolderPath -type directory | Out-Null
}
$demoToolkitFolderPath = Resolve-Path $demoToolkitFolderPath
	
$filePath = Join-Path $demoToolkitFolderPath "demo-toolkit.zip"

if(-NOT (Test-Path $filePath))
{
	Write-host "Downloading..."
	
    # Download demo-toolkit.zip File
    DownloadFile $filePath
    
    # UnBlock demo-toolkit.zip File (Zone.Identifier)
    UnblockFile $filePath
}

$filePath = Resolve-Path $filePath

Unzip $filePath $demoToolkitFolderPath
param([string]$configFilename)

$title = ""
$message = "Make sure to complete the $configFilename file. Then, press Y to continue or press N to exit."

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



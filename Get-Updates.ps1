param (
   [int] $VSVersion,
   [string] $VSEdition #Community, Professional, Enterprise
)

# Patch Tuesday
$location = Get-Location
$computer = $env:COMPUTERNAME
$VSBootstrapperPath = "C:\Users\Public\PS\Bootstrappers"
if ($VSEdition -eq "Community") {
   $VSFolder = "Preview"    
}
else {
   $VSFolder = $VSEdition
}

function Log {
   param (
      [Parameter(Mandatory = $true)]
      [string]$Message
   )

   # Logging Setup
   $source = "PowerShell"
   $logName = "Windows Powershell"
   $eventID = 600
   $entryType = [System.Diagnostics.EventLogEntryType]::Information
   $category = 8

   [System.Diagnostics.EventLog]::SourceExists($source) | Out-Null
   $eventLog = New-Object System.Diagnostics.EventLog($logName)
   $eventLog.Source = $source
   $eventLog.WriteEntry($Message, $entryType, $eventID, $category)
}

Write-Output "Sample parameters: .\Get-Updates.ps1 -VSVersion 2022 -VSEdition Community/Professional/Enterprise"
Write-Output ""
Write-Output "To function properly this script requires Boostrappers to be instlled at" 
Write-Output "$VSBootStrapperPath."
Write-Output ""
Write-Output "More info can be found here: https://learn.microsoft.com/en-us/visualstudio/install/command-line-parameter-examples?view=vs-2022#update-in-two-steps"
Write-Output ""
Write-Output "Bootstrappers: https://learn.microsoft.com/en-us/visualstudio/install/use-command-line-parameters-to-install-visual-studio?view=vs-2022"
Write-Output ""

# Update Visual Studio
Log "Updating Visual Studio $VSEdition..."
Write-Output "Updating Visual Studio $VSEdition..."

Set-Location $VSBootstrapperPath
Invoke-Expression ".\vs_$VSEdition.exe --update --noweb --all?"
Invoke-Expression ".\vs_$VSEdition.exe update --installPath C:\Program Files\Microsoft Visual Studio\$VSVersion\$VSFolder\ --quiet"
Set-Location $location

# Update Visual Studio Code
Log "Updating VS Code..."
Write-Output "Updating Visual Studio Code..."
Invoke-Expression "winget --version"
if ($?) {
   Invoke-Expression "winget upgrade Microsoft.VisualStudioCode --accept-source-agreements --accept-package-agreements"
}
else {
   Log "Winget not found, installing Winget..."
   Write-Output "Winget not found, installing Winget..."
   Invoke-Expression "winget install Microsoft.Winget"
}

# Update Azure Data Studio If Installed
if (Test-Path "C:\'Program Files\Azure Data Studio'\azuredatastudio.exe") {
   # If the command is found, run it
   Log "Updating Azure Data Studio..."
   Write-Output "Updating Azure Data Studio..."
   Get-Command C:\'Program Files\Azure Data Studio'\azuredatastudio.exe --update
}

# Update Windows Store Apps
Log "Updating Windows Store Apps..."
Write-Output "Updating Windows Store Apps..."
winget upgrade --all --accept-package-agreements

Write-Output "Update complete."
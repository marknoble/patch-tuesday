param (
   [int] $VSVersion,
   [string] $VSEdition #Preview, Community, Professional, Enterprise
)

# Patch Tuesday
$location = Get-Location
$computer = $env:COMPUTERNAME
$VSBootstrapperPath = "C:\Program Files (x86)\Microsoft Visual Studio\Installer"
if ($VSEdition -eq "Community") {
    $VSFolder = "Preview"    
}
else
{
    $VSFolder = $VSEdition
}
cls

Write-Output "Sample parameters: .\Get-Updates.ps1 -VSVersion 2022 -VSEdition Preview/Community/Professional/Enterprise"
Write-Output ""
Write-Output "To function properly this script requires Boostrappers to be instlled at" 
Write-Output "$VSBootStrapperPath."
Write-Output ""
Write-Output "More info can be found here: https://learn.microsoft.com/en-us/visualstudio/install/command-line-parameter-examples?view=vs-2022#update-in-two-steps"
Write-Output ""
Write-Output "Bootstrappers: https://learn.microsoft.com/en-us/visualstudio/install/use-command-line-parameters-to-install-visual-studio?view=vs-2022"
Write-Output ""

# Update Visual Studio
Write-EventLog -LogName "Windows Powershell" -Source "PowerShell" -EventId 600 -EntryType Information -Message "Updating VS $VSEdition..." -Category 8
Write-Output "Updating Visual Studio $VSEdition..."

cd $VSBootstrapperPath
Invoke-Expression ".\vs_$VSEdition.exe --update --noweb --all?"
Invoke-Expression ".\vs_$VSEdition.exe update --installPath C:\Program Files\Microsoft Visual Studio\$VSVersion\$VSEdition\ --quiet"

# Update Visual Studio Code
Write-EventLog -LogName "Windows Powershell" -Source "PowerShell" -EventId 600 -EntryType Information -Message "Updating VS Code..." -Category 8
Write-Output "Updating Visual Studio Code..."
Invoke-Expression "winget --version"
if ($?) {
   Invoke-Expression "winget upgrade Microsoft.VisualStudioCode --accept-source-agreements --accept-package-agreements"
} else {
   Write-EventLog -LogName "Windows Powershell" -Source "PowerShell" -EventId 600 -EntryType Information -Message "Winget not found, installing Winget..." -Category 8
   Write-Output "Winget not found, installing Winget..."
   Invoke-Expression "winget install Microsoft.Winget"
}

# Update Azure Data Studio If Installed
if (Test-Path "C:\'Program Files\Azure Data Studio'\azuredatastudio.exe") {
   # If the command is found, run it
   Write-EventLog -LogName "Windows Powershell" -Source "PowerShell" -EventId 600 -EntryType Information -Message "Opening Azure Data Studio..." -Category 8
   Write-Output "Updating Azure Data Studio..."
   Get-Command C:\'Program Files\Azure Data Studio'\azuredatastudio.exe --update
}

cd $location

# Update Windows Store Apps
Write-EventLog -LogName "Windows Powershell" -Source "PowerShell" -EventId 600 -EntryType Information -Message "Updating Windows Store..." -Category 8
Write-Output "Updating Windows Store Apps..."
$namespaceName = "root\cimv2\mdm\dmmap"
$className = "MDM_EnterpriseModernAppManagement_AppManagement01"
$wmiObj = Get-WmiObject -Namespace $namespaceName -Class $className
$result = $wmiObj.UpdateScanMethod()

Write-Output "Update complete."
# patch-tuesday
A PowerShell script for updating Windows and Dev Tools

Sample parameters: .\Get-Updates.ps1 -VSVersion 2022 -VSEdition Preview (other options are Community/Professional/Enterprise)

If you see errors, try running again with elevated privliges by running PowerShell or PowerShell ISE as Administrator.

## Pre-run set-up
**NOTE:** Before running, be sure to download the appropriate Bootstrapper and save it to the following path on your system: C:\Program Files (x86)\Microsoft Visual Studio\Installer 

(you could use a different path, just be sure to change the $VSBootstrapperPath value)

## Bootstrappers
Visual Studio Installer Bootstrappers can be obtained from the following page:

[Microsoft Learn: Use command-line parameters to install, update, and manage Visual Studio](https://learn.microsoft.com/en-us/visualstudio/install/use-command-line-parameters-to-install-visual-studio?view=vs-2022)

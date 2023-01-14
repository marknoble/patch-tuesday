# Script to check status code of a file full of URLs
# Created by: Mark Noble 2023-01-13

param (
        [Parameter(Mandatory = $true,
            ParameterSetName = 'Path',
            HelpMessage = 'Enter one or more filenames',
            Position = 0)]
        [string[]]$Path
        )

$URIList = Get-Content -Path $Path

Foreach ($Uri in $URIList) {
    Write-Output $Uri
    Write-Output "Secure"
    try{
        $req = Invoke-WebRequest -uri "https://$Uri"
        Write-output "Status Code: $($req.StatusCode)"
    } catch{
        Write-Output "Status Code: $($_.Exception.Response.StatusCode.Value__)"
    }

    Write-Output "Insecure"
    try{
        $req = Invoke-WebRequest -uri "http://$Uri"
        Write-output "Status Code: $($req.StatusCode)"
    } catch{
        Write-Output "Status Code: $($_.Exception.Response.StatusCode.Value__)"
    }
    Write-Output "" #Empty Line
}
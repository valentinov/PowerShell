<#
.SYNOPSIS
    Get information about IIS application pools on a remote server.

.DESCRIPTION
    The GetAppPools function retrieves details about IIS application pools (names and states)
    on a specified remote server using PowerShell remoting.

.PARAMETER ComputerName
    Specifies the target server where the IIS application pools information will be retrieved.

.PARAMETER AppPoolsPath
    Specifies the path to the IIS application pools. Default is "IIS:\AppPools".

.EXAMPLE
    GetAppPools -ComputerName "RemoteServer"

    $appPoolsInfo = GetAppPools -ComputerName "RemoteServer"
    $appPoolsInfo | Format-Table

.NOTES
    File: GetAppPools.ps1
    Author: Valentin Vecsernik

#>

function GetAppPools {
    param (
        [Parameter(Mandatory = $true)]
        [String]
        $ComputerName,

        [Parameter(Mandatory = $false)]
        [string]$AppPoolsPath = "IIS:\AppPools"
    )

    try {
        $result = Invoke-Command -ComputerName $ComputerName -ScriptBlock {
            param ($Path)
            Import-Module WebAdministration
            Get-ChildItem -Path $Path | Select-Object -Property Name, State
        } -ArgumentList $AppPoolsPath

        return $result
    }
    catch {
        Write-Error "Failed to retrieve IIS application pool information. Error: $($_.Exception.Message)"
    }
}

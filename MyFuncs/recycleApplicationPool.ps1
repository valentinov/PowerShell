<#
.SYNOPSIS
Recycles an IIS application pool on a remote server.

.DESCRIPTION
This function recycles an IIS application pool on a specified remote server. It connects to the server, identifies the matching application pool by name, and triggers a recycling action.

.PARAMETER PoolName
The name of the application pool to be recycled.

.PARAMETER ServerName
The name or IP address of the remote server where the application pool resides.

.NOTES
File Name      : RecycleAppPool.ps1
Author         : Valentin Vecsernik
Prerequisite   : PowerShell V3

.EXAMPLE
# Recycle the "MyAppPool" application pool on the remote server "ServerA"
RecycleAppPool -PoolName "MyAppPool" -ServerName "ServerA"
#>
function RecycleAppPool() {
    param (
        [Parameter(Mandatory = $true)]
        [String]
        $PoolName,

        [Parameter(Mandatory = $true)]
        [String]
        $ServerName
    )

    $session = New-PSSession -ComputerName $ServerName

    $scriptBlock = {
        param($PoolName)

        Import-Module WebAdministration -ErrorAction SilentlyContinue | Out-Null

        Try {
            $filteredPool = Get-ChildItem -Path "IIS:\AppPools" | Where-Object { $_.Name -like "*$PoolName*" }
            $filteredPool.Recycle()
            Write-Output "Application pool [$PoolName] on [$ServerName] server recycled successfully."
        }
        Catch {
            Write-Error "Failed to recycle application pool [$PoolName] on [$ServerName] server. Error: $($_.Exception.Message)"
        }
    }

    Invoke-Command -Session $session -ScriptBlock $scriptBlock -ArgumentList $PoolName

    Remove-PSSession -Session $session
}

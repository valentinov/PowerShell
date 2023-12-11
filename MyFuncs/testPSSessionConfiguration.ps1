<#
.SYNOPSIS
    Checks if a custom PowerShell session configuration exists on a remote server.

.DESCRIPTION
    The Test-PSSessionConfiguration function verifies the presence of a specific
    PowerShell session configuration on a remote server. It helps ensure that the
    required configuration is available before further actions are taken.

.PARAMETER ConfigurationName
    Specifies the name of the custom PowerShell session configuration to check.

.PARAMETER ServerName
    Specifies the name of the remote server on which to check the configuration.

.EXAMPLE
    Test-PSSessionConfiguration -ConfigurationName "MyConfig" -ServerName "RemoteServer"

.NOTES
    File: Test-PSSessionConfiguration.ps1
    Author: Valentin Vecsernik
    Version: 1.0
    Date: December 15, 2023

#>


function Test-PSSessionConfiguration {
    param (
        [Parameter(Mandatory = $true)]
        [string]$ConfigurationName,

        [Parameter(Mandatory = $true)]
        [string]$ServerName
    )

    try {
        $session = New-PSSession -ComputerName $ServerName -ErrorAction Stop

        $scriptBlock = {
            param ($ConfigurationName)

            Get-PSSessionConfiguration -Name $ConfigurationName -ErrorAction SilentlyContinue
        }

        # Check if the custom configuration exists on the remote computer
        $sessionConfig = Invoke-Command -Session $session -ScriptBlock $scriptBlock -ArgumentList $ConfigurationName

        if ($null -ne $sessionConfig) {
            Write-Host "OK! Custom configuration [$ConfigurationName] exists on [$ServerName] node."
            return $sessionConfig
        }
        else {
            Write-Host "FAIL! Custom configuration [$ConfigurationName] does not exist on [$ServerName]. Must register it!"
        }
    }
    catch {
        Write-Host "ERROR! Failed to check custom configuration on [$ServerName]. Error: [$($_.Exception.Message)]"
    }
    finally {
        # Ensure to close the PowerShell session
        if ($session.State -eq 'Opened') {
            Remove-PSSession -Session $session
        }
    }
}

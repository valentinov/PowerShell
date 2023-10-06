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
        Write-Host "ERROR! Failed to check custom configuration on [$ServerName]. Error: $($_.Exception.Message)"
    }
    finally {
        if ($session.State -eq 'Opened') {
            Remove-PSSession -Session $session
        }
    }
}

# Example usage:
# $config = Test-PSSessionConfiguration -ConfigurationName "MyConfig" -ServerName "Server1"
# if ($config -ne $null) {
#     # Do something with the configuration
# }

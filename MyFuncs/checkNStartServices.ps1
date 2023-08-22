<#
.SYNOPSIS
Checks and manages services on a specified server.

.DESCRIPTION
This function checks and manages services on a given server. It evaluates the services defined in the $Services list and performs actions such as changing startup type and starting stopped services.

.PARAMETER ServerName
The name of the server on which to check and manage services.

.EXAMPLE
CheckNStartServices -ServerName "Server01"

This example invokes the CheckNStartServices function to check and manage services on "Server01".

.NOTES
File Name      : CheckNStartServices.ps1
Author         : Valentin Vecsernik
Prerequisite   : PowerShell v3.0
#>

$Services = [System.Collections.Generic.List[string]]@(
    "IISADMIN-IIS Admin Service",
    "w32time-Windows Time",
    "W3SVC-World Wide Web",
    "ProfSvc-User Profile Service",
    "EventLog-Windows Event Log"
)

function CheckNStartServices() {
    param (
        [Parameter(Mandatory = $true)]
        [String]
        $ServerName
    )

    Write-Host "`n# Invoking [$($MyInvocation.MyCommand)] to check services #`n"

    foreach ($service in $Services) {
        $serviceHelper = $service.split('-')
        $SvName = $serviceHelper[0]
        $SvDisplayName = $serviceHelper[1]
        $Service = Get-Service "$SvName*" -ComputerName $ServerName | Where-Object { ($_.DisplayName -match "$SvDisplayName*" ) } | Select-Object -Property StartType, ServiceName, Status
        $ServiceStartType = $Service.StartType
        $ServiceName = $Service.ServiceName
        $ServiceStatus = $Service.Status

        # First set the start type to auto
        if ($ServiceStartType -eq "Disabled" -or $ServiceStartType -eq "Manual") {
            $warningMessage = "WARNING! On [$ServerName] [$ServiceName ($SvDisplayName) service] STARTUP TYPE: [$ServiceStartType]. Setting it to [auto]."
            $tmpcnt = $warningMessage.Length
            $line = -join ("`n", [String]::new("#", $tmpcnt), "`n")
            Write-Host "$line$warningMessage$line"
            try {
                cmd /c sc \\$ServerName config $ServiceName start=auto
            }
            catch {
                Write-Host "Failed to set startup type. Error: [$($_.Exception.Message)]"
            }
        }

        # If the servce is stopped then start it
        if ($ServiceStatus -eq "Stopped") {
            $warningMessage = "WARNING! On [$ServerName] [$ServiceName ($SvDisplayName) service] STATUS: [$ServiceStatus]. Starting it automatically."
            $tmpcnt = $warningMessage.Length
            $line = -join ("`n", [String]::new("#", $tmpcnt), "`n")
            Write-Host "$line$warningMessage$line"
            try {
                cmd /c sc \\$ServerName start $ServiceName
            }
            catch {
                Write-Host "Failed to start service. Error: [$($_.Exception.Message)]"
            }
            
        }
        # In other case print the service name and status
        else {
            Write-Host "[$ServiceName ($SvDisplayName)] STATUS is ["$Service.Status"]`n"
        }
    }
}

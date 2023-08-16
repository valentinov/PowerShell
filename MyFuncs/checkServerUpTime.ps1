<#
.SYNOPSIS
Checks the uptime of a remote server and returns the uptime information as an object.

.DESCRIPTION
This function calculates the uptime of a specified remote server by retrieving the last boot time
using WMI. It returns an object containing the server's name, uptime in minutes, and the formatted boot time.

.PARAMETER ServerName
The name of the remote server for which you want to check the uptime.

.NOTES
File Name      : checkServerUpTime.ps1
Author         : Valentin Vecsernik
Prerequisite   : PowerShell V2

.EXAMPLE
# Check the uptime of a server named "ServerA"
$uptimeInfo = CheckNodeUpTime -ServerName "ServerA"
$uptimeInfo.ServerName
$uptimeInfo.UptimeMinutes
$uptimeInfo.LastBootTime
#>
function CheckServerUpTime {
    param (
        [Parameter(Mandatory = $true, HelpMessage = "Specify the hostname of the remote server.")]
        [String]
        $ServerName
    )

    Try {
        # Get the last boot time of the server
        $BootUpTime = Get-WmiObject win32_operatingsystem -ComputerName $ServerName -ErrorAction Stop | 
            Select-Object @{LABEL = 'LastBootUpTime'; EXPRESSION = { $_.ConverttoDateTime($_.lastbootuptime) } }
        
        $DateTimeNow = Get-Date
        $UptimeMinutes = ([datetime]$DateTimeNow - [datetime]$BootUpTime.LastBootupTime).TotalMinutes

        # Format the boot time for display
        $FormattedBootTime = $BootUpTime.LastBootupTime.ToString("yyyy-MM-dd HH:mm:ss")

        # Display information and return a custom object
        Write-Host "`n[$ServerName] server Up Time in minutes: [$UptimeMinutes]. Last boot up time happened on [$FormattedBootTime]`n"
        $uptimeObject = [PSCustomObject]@{
            ServerName    = $ServerName
            UptimeMinutes = $UptimeMinutes
            LastBootTime  = $FormattedBootTime
        }

        return $uptimeObject
    }
    Catch {
        Write-Host "Error occurred while checking the uptime of server [$ServerName]: $($_.Exception.Message)" -ForegroundColor Red
        return $null
    }
}

<#
.SYNOPSIS
    Creates or updates a scheduled task on a remote server using PowerShell.

.DESCRIPTION
    The New-ScheduledTask function utilizes the ScheduledTask module to manage scheduled tasks. 
    It allows for the specification of parameters such as the target server, task name, file path/name, and start delay.

.PARAMETER Server
    Specifies the target server where the scheduled task will be created or updated.

.PARAMETER TaskName
    Specifies the name of the scheduled task. If not provided, a default task name is used.

.PARAMETER FilePathName
    Specifies the file path and name of the script or program to be executed by the scheduled task.

.PARAMETER StartDelaySeconds
    Specifies the delay in seconds before the scheduled task is executed. Default is 60 seconds.

.EXAMPLE
    New-ScheduledTask -Server "RemoteServer" -TaskName "MyTask" -FilePathName "C:\Path\To\Script.ps1" -StartDelaySeconds 120

.NOTES
    File: New-ScheduledTask.ps1
    Author: Valentin Vecsernik

#>

function New-ScheduledTask {
    param (
        [Parameter(Mandatory = $true)]
        [string]
        $Server,

        [Parameter(Mandatory = $false)]
        [string]
        $TaskName = "Some random task name",

        [Parameter(Mandatory = $true)]
        [string]
        $FilePathName,

        [Parameter(Mandatory = $false)]
        [int]
        $StartDelaySeconds = 60
    )

    try {
        $session = New-PSSession -ComputerName $Server -ErrorAction Stop

        $scriptBlock = {
            param ($TaskName, $FilePathName, $StartDelaySeconds)

            $TaskExists = Get-ScheduledTask -TaskName $TaskName -ErrorAction SilentlyContinue

            if ($null -eq $TaskExists) {
                $hlpMsg = "Creating"
            }
            else {
                $hlpMsg = "Updating"
                Unregister-ScheduledTask -TaskName $TaskName -Confirm:$false -ErrorAction Stop
            }

            $Action = New-ScheduledTaskAction -Execute 'Powershell.exe' -Argument "-File `"$FilePathName`""

            $Trigger = New-ScheduledTaskTrigger -Once -At (Get-Date).AddSeconds($StartDelaySeconds)

            Register-ScheduledTask -TaskName $TaskName -Action $Action -Trigger $Trigger -User "NT AUTHORITY\SYSTEM" -ErrorAction Stop

            Write-Host "`n$hlpMsg [$TaskName] scheduled task on [$env:COMPUTERNAME] node. Task is going to run in [$StartDelaySeconds] seconds...`n"
        }

        Invoke-Command -Session $session -ScriptBlock $scriptBlock -ArgumentList $TaskName, $FilePathName, $StartDelaySeconds

        Write-Host "Task creation/update completed successfully."
        $failedTask = $false
    }
    catch {
        Write-Error "Failed to create/update task. Error: $($_.Exception.Message)"
        $failedTask = $true
    }
    finally {
        if ($session.State -eq 'Opened') {
            Remove-PSSession -Session $session
        }
        if ($failedTask -eq $false) {
            Write-Host "`nKindly monitor the created [$TaskName] sheduled task."
        }
    }
}

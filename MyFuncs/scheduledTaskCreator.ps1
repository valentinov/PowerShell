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
    }
    catch {
        Write-Error "Failed to create/update task. Error: $($_.Exception.Message)"
    }
    finally {
        if ($session.State -eq 'Opened') {
            Remove-PSSession -Session $session
        }
        Write-Host "`nKindly monitor the created sheduled task."
    }
}

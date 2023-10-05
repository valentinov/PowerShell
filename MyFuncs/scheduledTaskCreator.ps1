function ScheduleTaskCreator {
    param (
        [Parameter(Mandatory = $true)]
        [String]
        $Server,
        [Parameter(Mandatory = $true)]
        [string]$FilePathName,
        [Parameter(Mandatory = $false)]
        [string]$TaskName = "Some random task name",
        [Parameter(Mandatory = $false)]
        [int]$StartItInSeconds = 60
    )

    $session = New-PSSession -ComputerName $Server

    $scriptBlock = {
        param($Server, $TaskName, $FilePathName)

        $TaskExists = Get-ScheduledTask -TaskName $TaskName -ErrorAction SilentlyContinue

        if ($null -eq $TaskExists) {
            $hlpMsg = "Creating"
        }

        else {
            $hlpMsg = "Updating"

            Try {
                Unregister-ScheduledTask -TaskName $TaskName -Confirm:$false
            }
            Catch {
                Write-Error "`nFailed to unregister Scheduled Task on [$Server] server. Error: $($_.Exception.Message)"
            }
        }

        Write-Host "`n$hlpMsg [$TaskName] scheduled task on [$Server]. Task is going to run in [$StartItInSeconds] seconds...`n"

        Try {
            $SecondsFromNow = New-TimeSpan -Seconds $StartItInSeconds

            $TriggerTime = (Get-Date).Add($SecondsFromNow)

            $Action = New-ScheduledTaskAction -Execute 'Powershell.exe' -Argument "-File `"$FilePathName`""

            $Trigger = New-ScheduledTaskTrigger -Once -At $TriggerTime

            Register-ScheduledTask -TaskName "$TaskName" -Action $Action -Trigger $Trigger -User "NT AUTHORITY\SYSTEM"
        }
        Catch {
            Write-Error "`nFailed to create a new Scheduled Task on [$Server] server. Error: $($_.Exception.Message)"
        }
    }

    Invoke-Command -Session $session -ScriptBlock $scriptBlock -ArgumentList $Server, $TaskName, $FilePathName

    Remove-PSSession -Session $session
    
    Write-Host "`nKindly monitor the created shedule task."
}

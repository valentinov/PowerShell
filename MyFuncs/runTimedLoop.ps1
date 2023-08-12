<#
.SYNOPSIS
Runs a timed loop for a specified duration, optionally allowing for early termination.

.DESCRIPTION
This function runs a loop for a specified duration in minutes while allowing customization of the sleep duration between loop iterations.
It also provides an option to stop the loop prematurely by setting the $stopLoop parameter to $true.

.PARAMETER DurationInMinutes
Specifies the maximum duration of the loop in minutes. The default is 5 minutes.

.PARAMETER SleepDurationSeconds
Specifies the sleep duration between loop iterations in seconds. The default is 20 seconds.

.NOTES
File Name      : RunTimedLoop.ps1
Author         : Valentin Vecsernik
Prerequisite   : PowerShell V2

.EXAMPLE
# Run the loop for 10 minutes with a sleep duration of 30 seconds
RunTimedLoop -DurationInMinutes 10 -SleepDurationSeconds 30
#>
function RunTimedLoop() {
    [CmdletBinding()]
    param (
    
        [Parameter(Mandatory = $false)]
        [int]
        $DurationInMinutes = 5,

        [Parameter(Mandatory = $false)]
        [int]
        $SleepDurationSeconds = 20
    )
    
    # Calculate the end time based on the duration
    $endTime = (Get-Date).AddMinutes($DurationInMinutes)

    # A boolean parameter for stop the loop if it is set to true
    $stopLoop = $false
    
    # Loop until the current time reaches the end time or $stopLoop is true
    while ((Get-Date) -lt $endTime -and !$stopLoop) {

        # Add the functions here...
    
        # Sleep for a certain period before calling the functions again
        Start-Sleep -Seconds $SleepDurationSeconds
    }
}

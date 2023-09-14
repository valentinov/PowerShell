<#
.SYNOPSIS
    Performs housekeeping tasks by deleting log files older than a specified number of days in a given folder.

.DESCRIPTION
    The HouseKeeping function is used to automate the cleanup of log files in a specified folder. 
    It checks if the folder exists, identifies log files that are older than a specified threshold,
    and deletes them. This function provides options to customize the folder, retention period, 
    and file extension for log files.

.PARAMETER LogFolderPath
    The folder path where log files are located.

.PARAMETER DaysToDelete
    The number of days to retain log files. Log files older than this number of days will be deleted.
    (Default: 3)

.PARAMETER FileExtension
    The file extension of log files to be deleted. Specify the extension as a wildcard pattern.
    (Default: "*.log")

.NOTES
    File Name      : houseKeeping.ps1
    Author         : Valentin Vecsernik
    Prerequisite   : PowerShell V3

.EXAMPLE
    HouseKeeping -LogFolderPath "C:\Logs" -DaysToDelete 7 -FileExtension "*.txt"
    This example will clean up text log files in the "C:\Logs" folder that are older than 7 days.

.EXAMPLE
    HouseKeeping -LogFolderPath "D:\AppLogs"
    This example will use default settings to clean up log files in the "D:\AppLogs" folder older than 3 days.

#>
function HouseKeeping {
    param (
        [string]$LogFolderPath,
        [int]$DaysToDelete = 3,
        [string]$FileExtension = "*.log"
    )

    # Check if the folder exists
    if (-not (Test-Path -Path $LogFolderPath -PathType Container)) {
        Write-Host "Folder [$LogFolderPath] does not exist."
        return
    }

    $DateTimeNow = Get-Date
    $LastWrite = $DateTimeNow.AddDays(-$DaysToDelete)
    $Files = Get-ChildItem $LogFolderPath -Include $FileExtension -Recurse | Where-Object { $_.LastWriteTime -le $LastWrite }

    if ($Files.Count -gt 0) {
        foreach ($File in $Files) {
            Write-Host "Deleting [$($File.FullName)]..."
            Try {
                Remove-Item $File.FullName -Force -ErrorAction Stop
                Write-Host "Deleted [$($File.FullName)]"
            }
            Catch {
                Write-Host "Error deleting [$($File.FullName)]. Exception: [$_]"
            }
        }
    } else {
        Write-Host "No files to delete."
    }
}

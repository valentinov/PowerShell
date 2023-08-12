<#
.SYNOPSIS
A simple folder creator function that provides verbose output.

.DESCRIPTION
This function creates a new folder at the specified path and provides verbose output for better visibility.

.PARAMETER FolderPath
The path where the new folder should be created.

.NOTES
File Name      : folderCreator.ps1
Author         : Valentin Vecsernik
Prerequisite   : PowerShell V2
#>
function New-Folder {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory = $true, ValueFromPipeline = $true, Position = 0)]
        [string]$FolderPath
    )

    if (!(Test-Path -Path $FolderPath -PathType Container)) {
        try {
            New-Item -Path $FolderPath -ItemType Directory -ErrorAction Stop
            Write-Verbose "SUCCESS! Folder created: [$FolderPath]"
        }
        catch {
            Write-Error "ERROR! Failed to create [$FolderPath] folder. Exception: [$_]"
        }
    }
    else {
        Write-Warning "WARNING! Folder already exists: [$FolderPath]"
    }
}

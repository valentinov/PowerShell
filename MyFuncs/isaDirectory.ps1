<#
.SYNOPSIS
    Determine whether a given path points to a directory or a file.

.DESCRIPTION
    The IsaDirectory function checks the specified path and returns one of the following:
    - "directory" if the path points to a directory.
    - "file" if the path points to a file.
    - Throws an error if the path is invalid or doesn't exist.

.PARAMETER targetPath
    Specifies the path to be checked. This parameter is mandatory.

.EXAMPLE
    PS C:\> IsaDirectory -targetPath "C:\MyDirectory"
    This will return "directory" if "C:\MyDirectory" is a valid directory path.

.EXAMPLE
    PS C:\> IsaDirectory -targetPath "C:\MyFile.txt"
    This will return "file" if "C:\MyFile.txt" is a valid file path.

.NOTES
File Name      : isaDirectory.ps1
Author         : Valentin Vecsernik
Prerequisite   : PowerShell V3
#>
function IsaDirectory {
    param (
        [Parameter(Mandatory = $true)]
        [String]$targetPath
    )

    if (Test-Path -Path $targetPath) {

        if (Test-Path -Path $targetPath -PathType Container) {
            Write-Verbose "The provided [$targetPath] is a directory"
            return "directory"
        }
        elseif (Test-Path -Path $targetPath -PathType Leaf) {
            Write-Verbose "The provided [$targetPath] is a file"
            return "file"
        }
    }
    else {
        Write-Error "Error! The provided [$targetPath] is invalid"
    }
}

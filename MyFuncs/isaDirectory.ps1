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

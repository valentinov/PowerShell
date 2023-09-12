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

# Example usage:
# HouseKeeping -LogFolderPath "C:\Logs" -DaysToDelete 7 -FileExtension "*.log"

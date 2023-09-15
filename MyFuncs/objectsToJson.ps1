function Convert-ObjectToJsonFile {
    param (
        [Parameter(Mandatory = $true)]
        [Object]$InputObject,
        
        [Parameter(Mandatory = $true)]
        [String]$OutputFilePath
    )
    
    try {
        # Convert the input object to JSON
        $jsonOutput = $InputObject | ConvertTo-Json

        # Write the JSON string to the output file
        $jsonOutput | Set-Content -Path $OutputFilePath

        Write-Host "JSON data has been written to [$OutputFilePath]"
    }
    catch {
        Write-Host "ERROR! Failed to create Json file. Exception: [$_]"
    }
}

function Get-JsonFile {
    param (
        [Parameter(Mandatory = $true)]
        [String]$Path
    )

    if (Test-Path -Path $Path -PathType Leaf) {
        try {
            # Read the content of the file as a single string and store it
            $jsonString = Get-Content -Path $Path -Raw

            # Convert the JSON string into PowerShell objects
            $jsonObjects = $jsonString | ConvertFrom-Json

            return $jsonObjects
        }
        catch {
            Write-Error "Error reading or converting JSON from [$Path $_]"
        }
    }
    else {
        Write-Error "File not found at [$Path]"
    }
}

# Create an array to store the custom objects
$serverObjects = @()

# Define server data for multiple servers
$server1 = New-Object PSObject -Property @{
    ServerName = "Server01"
    IPAddress  = "192.168.1.100"
    Status     = "Online"
}
$server2 = New-Object PSObject -Property @{
    ServerName = "Server02"
    IPAddress  = "192.168.1.101"
    Status     = "Offline"
}
$server3 = New-Object PSObject -Property @{
    ServerName = "Server03"
    IPAddress  = "192.168.1.102"
    Status     = "Online"
}

# Add the objects to the array
$serverObjects += $server1, $server2, $server3

# Convert and export objects to json file
Convert-ObjectToJsonFile -InputObject $serverObjects -OutputFilePath "full-path-to-some.json"

# Import json file to object
$importedServerObjects = Get-JsonFile -Path "full-path-to-some.json"

# Do a small filtering on the imported objects
$filteredServerObjects = $importedServerObjects | Where-Object { $_.Status -eq "Offline" }

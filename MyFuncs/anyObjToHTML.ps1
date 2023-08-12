<#
.SYNOPSIS
Converts any PowerShell objects into an HTML table with customizable formatting and coloring.

.DESCRIPTION
This function takes a PowerShell object as input and generates an HTML table that represents the object's data. The table can include custom header and footer content, and cell coloring based on specific conditions.

.PARAMETER InputObject
The PowerShell object to be converted into an HTML table. This object's properties will be used as columns in the table.

.PARAMETER Header
The header text to be displayed at the top of the generated HTML table.

.PARAMETER Footer
Optional. The footer text to be displayed at the bottom of the generated HTML table.

.NOTES
File Name      : anyObjToHTML.ps1
Author         : Valentin Vecsernik
Prerequisite   : PowerShell V2

.EXAMPLE
$sampleData = @(
    [PSCustomObject]@{ Server = "app001"; Pool = "A"; Endpoint = "http://app001/healthcheck.php"; Status = 200 }
    [PSCustomObject]@{ Server = "app002"; Pool = "B"; Endpoint = "http://app002/healthcheck.php"; Status = 503 }
)
$header = "User Information"
$footer = "Total users: $($sampleData.Count)"

$outputHtml = AnyObjectToHTMLTable -InputObject $sampleData -Header $header -Footer $footer
$outputHtml | Out-File -FilePath "table.html"
#>
function AnyObjectToHTMLTable() {
    param (
        [Parameter(Mandatory = $true, ValueFromPipeline = $true)]
        [PSObject]
        $InputObject,

        [Parameter(Mandatory = $true)]
        [String]
        $Header,

        [Parameter(Mandatory = $false)]
        [String]
        $Footer
    )

    begin {
        $html = "<h1>$Header</h1>"
        # Start the HTML table
        $html += "<table class=`"table table-bordered`">"
    }

    process {
        # Get the properties of the input object
        $properties = $InputObject | Get-Member -MemberType Properties | Select-Object -ExpandProperty Name

        # Create the table header
        $html += "<thead><tr>"
        foreach ($property in $properties) {
            $html += "<th>$property</th>"
        }
        $html += "</tr></thead>"

        # Create the table body
        $html += "<tbody><tr>"
        
        # Create the table rows dynamically
        foreach ($obj in $InputObject) {
            $html += "<tr>"
            foreach ($p in $properties) {
                $value = $obj.$p

                # Change the background color to green or red in some special cases
                $valueStr = $value.ToString()
                # green - ok
                if ($valueStr.toLower() -in "200", "started", "online") { 
                    $html += -join ("<td bgcolor=", '"LightGreen"', ">", $valueStr, "</td>")
                }
                # red - error
                elseif ($valueStr.toLower() -in "404", "500", "503", "stopped", "down" -or [string]::IsNullOrEmpty($valueStr)) {
                    # Handle empty value
                    if ([string]::IsNullOrEmpty($valueStr)) {
                        $valueStr = "NULL"
                    }
                    $html += -join ("<td bgcolor=", '"#f08080"', ">", $valueStr, "</td>")
                }

                else {
                    $html += "<td>$valueStr</td>"
                }
            }
            $html += "</tr>"

        }

        # Add a footer row with the right colspan to the table if there is Footer content
        if ($Footer) {
            $cntObj = $properties.Count
            $html += -join ("<tr>", "<td colspan=", '"', $cntObj, '"', ">", $Footer, "</td>", "</tr>")
        }
        $html += "</tbody>"
    }

    end {
        # End the HTML table
        $html += "</table>"
        
        # Return the complete HTML string
        return $html
    }
}

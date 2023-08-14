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
                $valueStr = $value.ToString().ToLower()
                $html += CheckNColorTableData -ValueSTR $valueStr
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

<#
Small helper for the HTML table creator function
Based on ValueSTR string input generates the standard HTML Table Data <td> formatting and color
Returns a $html string
#>
function CheckNColorTableData {
    param (
        [Parameter(Mandatory = $true)]
        [String]
        $ValueSTR
    )
    $td = ""  # Initialize the td string
    # green - ok
    if ($ValueSTR -in "200", "started", "online") { 
        $td += -join ("<td bgcolor=", '"LightGreen"', ">", $ValueSTR, "</td>")
    }
    # red - error
    elseif ($ValueSTR -in "404", "500", "503", "stopped", "down" -or [string]::IsNullOrEmpty($ValueSTR)) {
        # Handle empty value
        if ([string]::IsNullOrEmpty($ValueSTR)) {
            $ValueSTR = "NULL"
        }
        $td += -join ("<td bgcolor=", '"#f08080"', ">", $ValueSTR, "</td>")
    }
    # any other cases - no special formatting
    else {
        $td += "<td>$ValueSTR</td>"
    }

    return $td
}

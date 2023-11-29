<#
.SYNOPSIS
    Creates a decorative header with a specified message and character.

.DESCRIPTION
    The New-NiceHeader function generates a decorative header by repeating a specified character around the provided message.
    It is useful for enhancing the visual appearance of console output or log messages.

.PARAMETER Header
    Specifies the message or content to be included in the header.

.PARAMETER Char
    Specifies the character to be used for decorating the header. Should be a single character.

.EXAMPLE
    New-NiceHeader -Header "Important Information" -Char "*"
    
    Output:
    ***************
    Important Information
    ***************

.NOTES
    File: niceHeader.ps1
    Author: Valentin Vecsernik

#>

function New-NiceHeader {
    param (
        [Parameter(Mandatory = $true)]
        [String]
        $Header,

        [Parameter(Mandatory = $true)]
        [ValidateLength(1, 1)]
        [String]
        $Char
    )

    $tmpcnt = $Header.Length
    $line = [String]::new("$Char", $tmpcnt)
    $output = "`n$line`n$Header`n$line`n"

    $output
}

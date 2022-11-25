#Given array of integers
[System.Collections.Generic.List[int]]$x = @(5, 10, 11)

#Check the initial array - has to be an arraylist
function CheckArray($array) {

    return $array -is [System.Collections.Generic.List[int]]
}

#Count how many items we have in the initial array and returns it
function CountArray() {

    Param($array)

    if (CheckArray -array $array) {
        return $array.Count
    }
    else {
        return $false
    }
}

#Summation - find sum of its elements. Returns one int value 
function Summation() {

    Param([System.Collections.Generic.List[int]]$array,
        [Int]$numOfItems)

    $value = 0

    for ($i = 0; $i -lt $numOfItems; $i++) {
        $value += $array[$i]
    }

    return $value
}

#Summation short/one line version
function SummationOneLine([System.Collections.Generic.List[int]]$array, [Int]$numOfItems) {
    return (($array | ForEach-Object { $_ } | Measure-Object -Sum)).Sum
}

#Decision - checks odd numbers in the input array. Returns true as soon as finds the first odd (%2 != 0) value, else returns false.
function Decision() {

    Param([System.Collections.Generic.List[int]]$array,
        [int]$numOfItems)

    $i = 0

    while (($i -lt $numOfItems) -and ($x[$i] % 2 -ne 0)) {
        $i++
    }

    #if $i is less than the length of the array set $exist to true
    $exist = ($i -lt $numOfItems)

    return $exist
}

#Decision all - checks odd numbers. If all elements are odd (%2 == 1) returns true
function DecisionAll() {

    Param([System.Collections.Generic.List[int]]$array,
        [int]$numOfItems)

    $i = 0

    while (($i -lt $numOfItems) -and ($x[$i] % 2 -eq 1)) {
        $i++
    }

    $existAll = ($i -ge $numOfItems)

    return $existAll
}

#IsSorted - checks the order of the array. If it is sorted in ascending order returns true
function IsSorted([System.Collections.Generic.List[int]]$array, [Int]$numOfItems) {

    $i = 0

    while (($i -le $numOfItems - 1) -and ($array[$i] -le $array[$i + 1]) ) {
        $i++
    }

    $sorted = ($i -eq $numOfItems - 1)

    return $sorted
}

#Selection - returns the first position of the array where the element is odd
function Selection([System.Collections.Generic.List[int]]$array) {

    $i = 0

    while ($array[$i] % 2 -ne 0) {
        $i++
    }

    return $i
}

#LinearSearch - do we have an odd (%2 != 0) element? If yes returns true and its position
function LinearSearch([System.Collections.Generic.List[int]]$array, [Int]$numOfItems) {

    $i = 0

    while (($i -le $numOfItems) -and ($array[$i] % 2 -ne 0)) {
        $i++
    }

    $exist = ($i -le $numOfItems)

    LinearSearchPrintHelper
}

#LinearSearchValue - looking for a specific int value. If it is there returns true and its position
function LinearSearchValue([System.Collections.Generic.List[int]]$array, [Int]$numOfItems, [Int]$value) {

    $i = 0

    while (($i -le $numOfItems) -and ($array[$i] -ne $value)) {
        $i++
    }

    $exist = ($i -le $numOfItems)

    LinearSearchPrintHelper
}

#LinearSearchPrintHelper - small helper function for print LinearSearch and LinearSearchValue results to the console
function LinearSearchPrintHelper() {

    if ($exist) {
        $idx = $i
        Write-Host("$exist - $idx")
    }
    else {
        Write-Host($false)
    }
}

#Counting - count how many even (%2 == 0) numbers have in the array
function Counting([System.Collections.Generic.List[int]]$array, [Int]$numOfItems) {

    $pcs = 0

    for ($i = 0; $i -lt $numOfItems; $i++) {
        if ($array[$i] % 2 -eq 0) { $pcs++ }
    }

    return $pcs
}

#MaxSelection - returns the location of the maximum number
function MaxSelection([System.Collections.Generic.List[int]]$array, [Int]$numOfItems) {

    $max = 0

    for ($i = 1; $i -lt $numOfItems; $i++) {
        if ($array[$i] -gt $array[$max]) {
            $max = $i
        }
    }

    return $max
}

$n = CountArray -array $x

if ($n -is [Int]) {
    Write-Host("`nThe input array contains $n element(s). The elements are: $x`n")

    Write-Host("`nSummation")
    Summation -array $x -numOfItems $n
    
    Write-Host("`nSummation one liner")
    SummationOneLiner -array $x -numOfItems $n
    
    Write-Host("`nDecision (%2 != 0)")
    Decision -array $x -numOfItems $n
    
    Write-Host("`nDecision All")
    DecisionAll -array $x -numOfItems $n
    
    Write-Host("`nSorted in ascending order")
    IsSorted -array $x -numOfItems $n
    
    Write-Host("`nSelection")
    Selection -array $x
    
    Write-Host("`nLinear Search")
    LinearSearch -array $x -numOfItems $n
    
    Write-Host("`nLinear Search Value")
    LinearSearchValue -array $x -numOfItems $n -value 5
    
    Write-Host("`nCounting")
    Counting -array $x -numOfItems $n
    
    Write-Host("`nMaximum selection")
    MaxSelection -array $x -numOfItems $n
}

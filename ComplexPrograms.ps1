$x_1 = [System.Collections.Generic.List[int]]::new()
$x_2 = [System.Collections.Generic.List[int]]::new()
$x_1 = (1..7 | ForEach-Object { Get-Random -Minimum 1 -Maximum 30 })
$x_2 = (1..8 | ForEach-Object { Get-Random -Minimum 1 -Maximum 30 })

$m_1 = $x_1.Count

$m_2 = $x_2.Count

#Sort the even (%2 == 0) elements to the beginning of the array without swap
function Sort() {
    Param([System.Collections.Generic.List[int]]$array, [Int]$numOfItems)
    $left = 0
    $right = $numOfItems - 1
    $tmp = $array[0]
    $count = 0

    while ($left -lt $right) {
        while (($left -lt $right) -and ($array[$right] % 2 -ne 0)) {
            $right--
        }
        if ($left -lt $right) {
            $array[$left] = $array[$right]
            $left++
            while (($left -lt $right) -and ($array[$left] % 2 -eq 0)) {
                $left++
            }
            if ($left -lt $right) {
                $array[$right] = $array[$left]
                $right--
            }
        }
    }
    $array[$left] = $tmp
    if ($array[$left] % 2 -eq 0) {
        $count = $left
    }
    else {
        $count = $left - 1
    }
    return $array, $count
}

#Check the two input array for common element. If finds one return true
function CommonElement () {

    Param([System.Collections.Generic.List[int]]$array_1, [Int]$numOfItems_1,
        [System.Collections.Generic.List[int]]$array_2, [Int]$numOfItems_2)
    
    $i = 0
    $exist = $false

    while ($i -le $numOfItems_1 -and !$exist) {
        $j = 0
        while ($j -le $numOfItems_2 -and $array_1[$i] -ne $array_2[$j]) {
            $j++
        }
        if ($j -le $numOfItems_2) {
            $exist = $true
        }
        else {
            $i++
        }
    }

    Return $exist
}

#Intersection
function Intersection () {

    Param([System.Collections.Generic.List[int]]$array_1, [Int]$numOfItems_1,
        [System.Collections.Generic.List[int]]$array_2, [Int]$numOfItems_2)
    
    $y = [System.Collections.Generic.List[int]]::new()
    $count = 0

    for ($i = 0; $i -lt $numOfItems_1; $i++) {
        $j = 0
        while ( ($j -le $numOfItems_2) -and ($array_1[$i] -ne $array_2[$j]) ) {
            $j++
        }

        if ($j -le $numOfItems_2) {
            $y.Add($array_1[$i])
            $count++
        }
    }
    
    Return ($y, $count)
}

#Union
function Union() {

    Param([System.Collections.Generic.List[int]]$array_1, [Int]$numOfItems_1,
        [System.Collections.Generic.List[int]]$array_2, [Int]$numOfItems_2)

    $y = [System.Collections.Generic.List[int]]::new()
    $count = 0

    for ($i = 0; $i -lt $numOfItems_1; $i++) {
        $y.Add($array_1[$i])
    }
    $count = $numOfItems_1

    for ($j = 0; $j -lt $numOfItems_2; $j++) {
        $i = 0
        while (($i -le $numOfItems_1) -and ($array_1[$i] -ne $array_2[$j])) {
            $i++
        }
        if ($i -gt $numOfItems_1) {
            $y.Add($array_2[$j])
            $count++
        }
    }
    
    Return ($y, $count)
}
Write-Host("Sort")
Sort -array $x_1 -numOfItems $m_1

Write-Host("Intersection")
Intersection -array_1 $x_1 -numOfItems_1 $m_1 -array_2 $x_2 -numOfItems_2 $m_2

Write-Host("CommonElement")
CommonElement -array_1 $x_1 -numOfItems_1 $null -array_2 $x_2 -numOfItems_2 $m_2

Write-Host("Unioin")
Union -array_1 $x_1 -numOfItems_1 $m_1 -array_2 $x_2 -numOfItems_2 $m_2

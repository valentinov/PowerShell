#Sort the even (%2 == 0) elements to the beginning of the array without swap
function Sort() {

    Param([System.Collections.Generic.List[int]]$array, [Int]$numOfItems)
    
    $left = 0
    $right = $numOfItems-1
    $tmp = $array[0]
    $pc = 0

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
        $pc = $left
    }
    else {
        $pc = $left - 1
    }
    
    Return ($array, $pc)
}

#Intersection
function Intersection () {

    Param([System.Collections.Generic.List[int]]$array_1, [Int]$numOfItems_1,
        [System.Collections.Generic.List[int]]$array_2, [Int]$numOfItems_2)
    
    $y = [System.Collections.Generic.List[int]]::new()
    $pc = 0

    for ($i = 0; $i -lt $numOfItems_1; $i++) {
        $j = 0
        while ( ($j -le $numOfItems_2) -and ($array_1[$i] -ne $array_2[$j]) ) {
            $j++
        }

        if ($j -le $numOfItems_2) {
            $y.Add($array_1[$i])
            $pc++
        }
    }
    
    Return($y, $pc)
}

#Union
function Union() {

    Param([System.Collections.Generic.List[int]]$array_1, [Int]$numOfItems_1,
        [System.Collections.Generic.List[int]]$array_2, [Int]$numOfItems_2)

    $y = [System.Collections.Generic.List[int]]::new()
    $pc = 0

    for ($i = 0; $i -lt $numOfItems_1; $i++) {
        $y.Add($array_1[$i])
    }
    $pc = $numOfItems_1

    for ($j = 0; $j -lt $numOfItems_2; $j++) {
        $i = 0
        while (($i -le $numOfItems_1) -and ($array_1[$i] -ne $array_2[$j])) {
            $i++
        }
        if ($i -gt $numOfItems_1) {
            $y.Add($array_2[$j])
            $pc++
        }
    }
    
    Return ($y, $pc)
}

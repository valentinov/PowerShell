#Intersection
function Intersection () {

    Param([System.Collections.Generic.List[int]]$array_1, [Int]$numOfItems_1,
        [System.Collections.Generic.List[int]]$array_2, [Int]$numOfItems_2)
    
    $y = [System.Collections.Generic.List[int]]::new()
    $db = 0

    for ($i = 0; $i -lt $numOfItems_1; $i++) {
        $j = 0
        while ( ($j -le $numOfItems_2) -and ($array_1[$i] -ne $array_2[$j]) ) {
            $j++
        }

        if ($j -le $numOfItems_2) {
            $y.Add($array_1[$i])
            $db++
        }
    }
    
    Return($y, $db)
}

#Union
function Union() {

    Param([System.Collections.Generic.List[int]]$array_1, [Int]$numOfItems_1,
        [System.Collections.Generic.List[int]]$array_2, [Int]$numOfItems_2)

    $y = [System.Collections.Generic.List[int]]::new()
    $db = 0

    for ($i = 0; $i -lt $numOfItems_1; $i++) {
        $y.Add($array_1[$i])
    }
    $db = $numOfItems_1

    for ($j = 0; $j -lt $numOfItems_2; $j++) {
        $i = 0
        while (($i -le $numOfItems_1) -and ($array_1[$i] -ne $array_2[$j])) {
            $i++
        }
        if ($i -gt $numOfItems_1) {
            $y.Add($array_2[$j])
            $db++
        }
    }
    
    Return ($y, $db)
}

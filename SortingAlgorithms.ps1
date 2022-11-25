#Selection sort O(n^2)
function SelectionShort($targetList, [Int]$numOfItems) {

    for ($i = 0; $i -lt $numOfItems; $i++) {
        $min = $i
        for ($j = $i + 1; $j -lt $numOfItems; $j++) {
            if ($targetList[$min] -gt $targetList[$j]) {
                $min = $j
            }
        }
        
        SwapHelper -target $targetList -a $i -b $min
    }
}

#Helper functon to swap two elements in a list
function SwapHelper($target, $a, $b) {
    $tmp = $target[$a]
    $target[$a] = $target[$b]
    $target[$b] = $tmp
}

$randomList = [System.Collections.Generic.List[int]]::new()

$randomList = (1..5 | ForEach-Object { Get-Random -Minimum 1 -Maximum 311 })

$n = $randomList.Count

SelectionShort -targetList $randomList -numOfItems $n

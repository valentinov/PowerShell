#Selection sort O(n^2)
function SelectionSort($targetList, [Int]$numOfItems) {

    for ($i = 0; $i -lt $numOfItems; $i++) {
        $min = $i

        for ($j = $i + 1; $j -lt $numOfItems; $j++) {
            if ($targetList[$min] -gt $targetList[$j]) {
                $min = $j
            }
        }
        SwapHelper -list $targetList -a $i -b $min
    }
}

#Bubble sort O(n^2)
function BubbleSort($targetList, [Int]$numOfItems) {

    $i = $numOfItems - 1

    while ($i -gt 0) {
        $idx = 0

        for ($j = 0; $j -lt $i; $j++) {
            if ($targetList[$j] -gt $targetList[$j + 1]) {
                SwapHelper -list $targetList -a $j -b ($j + 1)
                $idx = $j
            }
        }
        $i = $idx
    }
}

#Insertion sort O(n^2)
function InsertionSort($targetList, [Int]$numOfItems) {

    for ($i = 1; $i -lt $numOfItems; $i++) {
        $j = $i - 1
        $helper = $targetList[$i]

        while (($j -gt 0) -and ($targetList[$j] -gt $helper)) {
            $targetList[$j + 1] = $targetList[$j]
            $j = $j - 1
        }

        $targetList[$j + 1] = $helper
    }
}

#Helper function to swap two elements in a list
function SwapHelper($list, $a, $b) {
    $tmp = $list[$a]
    $list[$a] = $list[$b]
    $list[$b] = $tmp
}

$randomList = [System.Collections.Generic.List[int]]::new()
$randomList = (1..5 | ForEach-Object { Get-Random -Minimum 1 -Maximum 311 })

Write-Host($randomList)
$n = $randomList.Count

#SelectionSort -targetList $randomList -numOfItems $n

#BubbleSort -targetList $randomList -numOfItems $n

#InsertionSort -targetList $randomList -numOfItems $n

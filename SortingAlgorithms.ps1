#Selection sort
function SelectionSort($array, $numOfItems) {

    for ($i = 0; $i -lt $numOfItems; $i++) {
        $min = $i
        for ($j = $i + 1; $j -lt $numOfItems; $j++) {
            if ($array[$min] -gt $array[$j]) {
                $min = $j
            }
        }
        $tmp = $array[$i]
        $array[$i] = $array[$min]
        $array[$min] = $tmp
    }
}

$list = (1..3 | ForEach-Object { Get-Random -Minimum 1 -Maximum 300 })

$n = $list.Count

SelectionShort -array $list -numOfItems $n

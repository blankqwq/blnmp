<?php

function mao_sort($arr)
{
    for ($i = count($arr)-1; $i > 0; $i--) {
        for ($j = 0; $j < $i; $j++) {
            if ($arr[$j] >$arr[$i]) {
                $temp = $arr[$j];
                $arr[$j] = $arr[$i];
                $arr[$i] = $temp;
            }
        }
    }
    return $arr;
}


function select_sort($arr)
{
    for ($i = count($arr)-1; $i >0; $i--) {
        $temp = $i;
        for($j=0;$j<$i;$j++){
            if($arr[$temp]<$arr[$j]){
                $temp = $j;
            }
        }
        $t = $arr[$temp];
        $arr[$temp] = $arr[$i];
        $arr[$i] =  $t;
    }
    return $arr;
}


function quick_sort($arr){
    if(count($arr)<=1){
        return $arr;
    }
    $middle = $arr[0];
    $left = $right = [];
    for($i=1;$i<count($arr);$i++){
        if($arr[$i]<$middle){
            $left[] = $arr[$i];
        }else{
            $right[] = $arr[$i];
        }
    }

    $left = quick_sort($left);
    $left[] = $middle;
    $right = quick_sort($right);
    return array_merge($left,$right);
}
var_dump(mao_sort([5, 4, 1, 6, 3]));
echo "<br>";
var_dump(select_sort([5, 4, 1, 6, 3]));
echo "<br>";
var_dump(quick_sort([5, 4, 1, 6, 3]));
echo "<br>";
echo "getShell";

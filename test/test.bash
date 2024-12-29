#!/bin/bash

ng () {
    echo ${1}行目が違う
    res=1
}

res=0

out=$(cat /tmp/mypkg.log)
now_date=$(TimeZone="Asia/Tokyo" date "+%Y/%m/%d %H:%M:%S")

echo "現在時刻: $now_date"
echo "out: $out"
[[ "$out" == *"現在時刻: $now_date,"* ]] || ng "$LINENO"

[[ "$out" == *"経過時刻: 1.00秒"* ]] || ng "$LINENO"

[ "$res" = 0 ] && echo OK
exit $res

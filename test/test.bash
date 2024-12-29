#!/bin/bash

dir=~
[ "$1" != "" ] && dir="$1"

ng() {
    echo "${1}行目が違う"
    res=1
}

res=0

timeout 10 ros2 launch mypkg timer_listen.launch.py > /tmp/mypkg.log

out=$(cat /tmp/mypkg.log)

now_date=$(echo "$time" | awk -F '現在時刻:' '{print $2}' | awk -F ',' '{print $1}')

time=$(echo "$out" | grep '現在時刻:')
echo "$out" | grep -q "現在時刻:" || ng "$LINENO"
echo "$out" | grep -q '経過時刻:1.00秒' || ng "$LINENO"

if [ "$res" = 0 ]; then
    echo "OK"
fi

exit $res

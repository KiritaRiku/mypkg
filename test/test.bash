#!/bin/bash

dir=~
[ "$1" != "" ] && dir="$1"

cd $dir/ros2_ws
colcon build

source install/setup.bash
source install/local_setup.bash
source $dir/.bashrc

ng() {
    echo "${1}行目が違う"
    res=1
}

res=0

timeout 10 ros2 launch mypkg timer_listen.launch.py > /tmp/mypkg.log

out=$(cat /tmp/mypkg.log)

echo grep -q "現在時刻:" "$out" || ng "$LINENO"
echo grep -q '経過時刻:1.00秒' "$out" || ng "$LINENO"


if [ "$res" = 0 ]; then
    echo "OK"
fi

exit $res

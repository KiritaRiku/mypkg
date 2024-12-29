#!/bin/bash

dir=~
[ "$1" != "" ] && dir="$1"

cd $dir/ros2_ws
colcon build

source install/setup.bash
source install/local_setup.bash
source $dir/.bashrc

timeout 10 ros2 launch mypkg timer_listen.launch.py > /tmp/mypkg.log
cat /tmp/mypkg.log
grep  "現在時刻:"
grep  '経過時刻:1.00秒'

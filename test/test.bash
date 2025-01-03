#!/bin/bash
# SPDX-FileCopyrightText: 2024 Kirita Riku <rikuribo1128@icloud.com>
# SPDX-License-Identifier: BSD-3-Clause

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

timeout 300 ros2 run mypkg timer 

ros2 topic echo /time_information std_msgs/msg/String  --once | grep "3分経過しました!"
ros2 topic echo /time_information std_msgs/msg/String --once | grep "5分経過しました!ノードを停止します。"


if [ "$res" = 0 ]; then
    echo "OK"
fi

exit $res

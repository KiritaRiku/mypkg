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

res=0


ros2 run mypkg timer &
NODE_PID=$!


ros2 topic echo /time_information std_msgs/msg/String >> /tmp/mypkg.log &
TOPIC_PID=$!


sleep 350

if grep -q "3分経過しました!" /tmp/mypkg.log; then
    echo "3分経過を確認"
else
    echo "3見つかりません"
    res=1
fi



if grep -q "5分経過しました！ノードを停止します。" /tmp/mypkg.log; then
    echo "5分経過を確認"
else
    echo "5見つかりません"
    res=1
fi


ros2 node list | grep -q mypkg.timer && ros2 node shutdown mypkg.timer


kill $TOPIC_PID


if [ "$res" = 0 ]; then
    echo "OK"
else
    echo "エラーが発生しました"
fi

exit $res


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

# ノードをフォアグラウンドで実行
echo "ノードのフォアグラウンド実行を開始します"
ros2 run mypkg timer & # ノードをバックグラウンドで起動
NODE_PID=$!

# トピックの出力をログに保存
echo "トピックの出力をログに保存します: /tmp/mypkg.log"
ros2 topic echo /time_information std_msgs/msg/String >> /tmp/mypkg.log &
TOPIC_PID=$!

# 400秒間待機してトピックの出力を確保
echo "350秒間の待機を開始します"
sleep 350


# 3分経過メッセージを確認
echo "3分経過メッセージを確認します"
if grep -q "3分経過しました!" /tmp/mypkg.log; then
    echo "3分経過メッセージを確認しました"
else
    echo "3分経過メッセージが見つかりません"
    res=1
fi

# 5分経過メッセージを確認
echo "5分経過メッセージを確認します"
if grep -q "5分経過しました！ノードを停止します。" /tmp/mypkg.log; then
    echo "5分経過メッセージを確認しました"
else
    echo "5分経過メッセージが見つかりません"
    res=1
fi

# ノードのシャットダウン
echo "ノードをシャットダウンします"
ros2 node list | grep -q mypkg.timer && ros2 node shutdown mypkg.timer
echo "ノードがシャットダウンしました"

# トピックのプロセスをシャットダウンします
echo "トピックのプロセスをシャットダウンします"
kill $TOPIC_PID
echo "トピックのプロセスがシャットダウンしました"

# 結果の確認
if [ "$res" -eq 0 ]; then
    echo "OK"
else
    echo "エラーが発生しました"
fi

exit $res


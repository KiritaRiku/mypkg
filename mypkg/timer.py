import rclpy
from rclpy.node import Node
from std_msgs.msg import String
import time
from datetime import datetime
import subprocess


def progress_bar(elapsed_time, total_time=300, length=30):
    progress = elapsed_time / total_time
    fill_length = int(length * progress)
    bar = f"[{'-' * fill_length}{' ' * (length - fill_length)}]"
    return bar


def timer_cb():
    global node, pub, start_time
    now_time = subprocess.getoutput('date')
    elapsed_time = time.time() - start_time

    minutes = int(elapsed_time) // 60
    seconds = int(elapsed_time) % 60

    progress = progress_bar(elapsed_time, 300)

    # 3分経過時にメッセージを送信
    if 180 <= elapsed_time < 181:
        msg = (
            f"現在時刻: {now_time}\n"
            f"経過時刻: {elapsed_time:.1f}秒\n"
            f"残り時間: {progress}\n"
            f"3分経過しました!"
        )
        pub.publish(String(data=msg))

    # 5分経過時にメッセージを送信し、ノードを停止
    if elapsed_time >= 300:
        msg = (
            f"現在時刻: {now_time}\n"
            f"経過時刻: {elapsed_time:.1f}秒\n"
            f"残り時間: {progress}\n"
            f"5分経過しました！ノードを停止します。"
        )
        pub.publish(String(data=msg))
        rclpy.shutdown()

    # 定期的にメッセージを送信
    else:
        msg = (
            f"現在時刻: {now_time}\n"
            f"経過時刻: {elapsed_time:.1f}秒\n"
            f"残り時間: {progress}"
        )
        pub.publish(String(data=msg))


def main():
    global node, pub, start_time

    rclpy.init()
    node = Node("timer_pub")
    pub = node.create_publisher(String, "time_information", 10)
    start_time = time.time()

    node.create_timer(1.0, timer_cb)

    rclpy.spin(node)


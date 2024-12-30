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

    if minutes > 0:
        time_num = f"{minutes}:{seconds:02d}"
    else:
        time_num = f"{seconds}秒"


    if elapsed_time >= 180 and elapsed_time < 190:
        node.get_logger().info("3分経過しました!")


    if elapsed_time >= 300:
        node.get_logger().info("5分経過しました！")
        node.get_logger().info("5分経過したので、ノードを停止します")
        rclpy.shutdown()


    msg = (
        f"現在時刻: {now_time}\n"
        f"経過時刻: {elapsed_time:.1f}秒\n"
        f"残り時間: {progress}"
    )

    #msg = f"現在時刻:{now_time}, 経過時刻:{elapsed_time:.1f}秒"
    #msg += f" 経過状況: {progress}"

    #node.get_logger().info(f"現在時刻: {now_time}")
    #node.get_logger().info(f"経過時刻: {elapsed_time:.1f}秒")
    #node.get_logger().info(f"残り時間: {progress}")
    

    pub.publish(String(data=msg))
    node.get_logger().info(msg)

def main():
    global node, pub, start_time

    rclpy.init()
    node = Node("timer_pub")
    pub = node.create_publisher(String, "time_information", 10)
    start_time = time.time()
    
    node.create_timer(1.0, timer_cb)

    rclpy.spin(node)()

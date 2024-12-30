import rclpy
from rclpy.node import Node
from std_msgs.msg import String
import time
from datetime import datetime

def timer_cb():
    global node, pub, start_time
    now_time = datetime.now().strftime("%Y/%m/%d %H:%M:%S")
    elapsed_time = time.time() - start_time
    msg = f"現在時刻:{now_time},経過時刻:{elapsed_time:.2f}秒"

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

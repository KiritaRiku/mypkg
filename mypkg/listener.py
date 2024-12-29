import rclpy
from rclpy.node import Node
from std_msgs.msg import String

def cb(msg):
    node.get_logger().info(f"Listen: {msg.data}")

def main():
    rclpy.init()
    global node
    node = Node("listener")
    node.create_subscription(String, "time_infomation", cb, 10)
    node.get_logger().info("Now listen")
    rclpy.spin(node)

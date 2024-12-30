import launch
import launch.actions
import launch.substitutions
import launch_ros.actions


def generate_launch_description():

    timer = launch_ros.actions.Node(
        package='mypkg',
        executable='timer',
        output='screen'
        )

    return launch.LaunchDescription([timer])

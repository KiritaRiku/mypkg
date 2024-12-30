# SPDX-FileCopyrightText: 2024 Kirita Riku <rikuribo1128@icloud.com>
# SPDX-License-Identifier: BSD-3-Clause

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

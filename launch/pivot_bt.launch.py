from launch import LaunchDescription
from launch_ros.actions import Node

def generate_launch_description():
    return LaunchDescription([
        Node(
            package='isaac_fetchbot',
            executable='bt_pivot_angle_node_runner',
            name='bt_pivot_angle_node',
            output='screen',
            parameters=[],
            arguments=['--bt_xml', 'pivot_bt.xml'],
            additional_env={
                'AMENT_PREFIX_PATH': '/home/bd/workspaces_nondocker/isaac_ros-dev/install:'
            }
        )
    ])

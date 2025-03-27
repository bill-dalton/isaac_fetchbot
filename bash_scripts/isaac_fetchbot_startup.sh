#!/bin/bash
# THis is: isaac_fetchbot_startup.sh
# THis runs on R16 to launch things needed for Fetchbot
# To start from comand line (eventually start from a systemd service upon startup
#   bd@R16:~$ /home/bd/workspaces_nondocker/isaac_ros-dev/src/isaac_fetchbot/bash_scripts/isaac_fetchbot_startup.sh

# CHRONY - This just cchecks, otherwise doesn't do anything
# gnome-terminal --title="CHRONY" --geometry=60x12 -- $SHELL -c "chronyc -n tracking"
      # to also check: $ systemctl status chronyd

# RVIZ2
gnome-terminal --title="RVIZ2" --geometry=49x11+0+0  -- $SHELL -c "cd ~/workspaces_nondocker/isaac_ros-dev && rviz2"

# NAV2 BRINGUP R16_LOCALIZATION_lAUNCH - MAP SERVER & AMCL
gnome-terminal --title="MAP SERVER & AMCL" --geometry=49x11+100+50  -- $SHELL -c "cd ~/workspaces_nondocker/isaac_ros-dev && ros2 launch nav2_bringup r16_localization_launch.py map:=/home/bd/workspaces_nondocker/isaac_ros-dev/src/isaac_fetchbot/maps/my_map_1618_combined_windows_restored.yaml"

# SET INITIAL POSITION
gnome-terminal --title="SET INITIAL POSITION" --geometry=49x11+200+100  -- $SHELL -c "ros2 topic pub -1 /initialpose geometry_msgs/PoseWithCovarianceStamped '{ header: {stamp: {sec: 0, nanosec: 0}, frame_id: "map"}, pose: { pose: {position: {x: 0.0, y: 0.0, z: 0.0}, orientation: {x: 0.0, y: 0.0, z: 0.0, w: 1.0}}, } }'"

# NAV2 BRINGUP R16_NAVIGATION_LAUNCH - BRINGS UP...
  # controller_server', 'smoother_server', 'planner_server', 'behavior_server', 'bt_navigator', 'waypoint_follower', 'velocity_smoother'
gnome-terminal --title="NAVIGATION" --geometry=49x11+300+150  -- $SHELL -c "cd ~/workspaces_nondocker/isaac_ros-dev && ros2 launch nav2_bringup r16_navigation_launch.py"

# CORRECT robot_radius PARAM
gnome-terminal --title="Set global robot_radius" --geometry=49x11+0+0  -- $SHELL -c "ros2 param set /global_costmap/global_costmap robot_radius 0.25"
gnome-terminal --title="Set local robot_radius" --geometry=49x11+0+0  -- $SHELL -c "ros2 param set /local_costmap/local_costmap robot_radius 0.25"

# TELEOP TWIST
gnome-terminal --title="TELEOP TWIST" --geometry=49x11+400+200  -- $SHELL -c "ros2 run teleop_twist_keyboard teleop_twist_keyboard"

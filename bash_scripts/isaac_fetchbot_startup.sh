#!/bin/bash
# THis is: isaac_fetchbot_startup.sh
# THis runs on R16 to launch things needed for Fetchbot
# To start from comand line (eventually start from a systemd service upon startup
#   bd@R16:~$ /home/bd/workspaces_nondocker/isaac_ros-dev/src/isaac_fetchbot/bash_scripts/isaac_fetchbot_startup.sh
#   bd@R16:~$ sudo ntpdate time.nist.gov
#   bd@R16:~$ ros2 run tf2_tools view_frames
#   bd@R16:~$ ros2 run tf2_ros tf2_echo map tag16h5:8
#   bd@R16:~$ ros2 run tf2_ros tf2_monitor map   tag16h5:8
#   bd@R16:~$ ros2 topic pub --once /voice_commands std_msgs/msg/String '{data: "Felicity pivot 90 degrees"}'
#   bd@R16:~$ ros2 topic pub --once /voice_commands std_msgs/msg/String '{data: "Felicity go to the table"}'

# CHRONY - This just cchecks, otherwise doesn't do anything
# gnome-terminal --title="CHRONY" --geometry=60x12 -- $SHELL -c "chronyc -n tracking"
      # to also check: $ systemctl status chronyd
      # to also check: $ chronyc -n sourcestats
      # to also check: $ chronyc tracking
      # maybe: $ sudo chronyc makestep  (on each machine??)

# RVIZ2
# gnome-terminal --title="RVIZ2" --geometry=49x11+0+0  -- $SHELL -c "cd ~/workspaces_nondocker/isaac_ros-dev && rviz2 -d /home/bd/my_fetchbot_humble_R16.rviz"
gnome-terminal --title="RVIZ2 MINIMAL" --geometry=49x11+500+500  -- $SHELL -c "cd ~/workspaces_nondocker/isaac_ros-dev && rviz2 -d /home/bd/my_fetchbot_humble_R16_minimal.rviz"

# NAV2 BRINGUP MAP SERVER [NO AMCL AFTER 19aUG2025]
# gnome-terminal --title="MAP SERVER & AMCL" --geometry=49x11+100+100  -- $SHELL -c "cd ~/workspaces_nondocker/isaac_ros-dev && ros2 launch nav2_bringup r16_localization_launch.py map:=/home/bd/workspaces_nondocker/isaac_ros-dev/src/isaac_fetchbot/maps/my_map_1618_combined_windows_restored.yaml"
#gnome-terminal --title="MAP SERVER & AMCL" --geometry=49x11+100+100  -- $SHELL -c "cd ~/workspaces_nondocker/isaac_ros-dev && ros2 launch nav2_bringup r16_localization_launch.py map:=/home/bd/workspaces_nondocker/isaac_ros-dev/src/isaac_fetchbot/maps/my_map_1618_combined_windows_restored_no_tv.yaml"
#gnome-terminal --title="AMCL" --geometry=49x11+100+100  -- $SHELL -c "cd ~/workspaces_nondocker/isaac_ros-dev && ros2 launch nav2_bringup r16_nav2_amcl_launch.py map:=/home/bd/workspaces_nondocker/isaac_ros-dev/src/isaac_fetchbot/maps/my_map_1618_combined_windows_restored_no_tv.yaml"
gnome-terminal --title="MAP SERVER" --geometry=49x11+100+100  -- $SHELL -c "cd ~/workspaces_nondocker/isaac_ros-dev && ros2 launch nav2_bringup r16_nav2_map_server_launch.py map:=/home/bd/workspaces_nondocker/isaac_ros-dev/src/isaac_fetchbot/maps/my_map_1618_combined_windows_restored_no_tv.yaml"

# NAV2 BRINGUP KEEPOUT SERVER
gnome-terminal --title="KEEPOUT SERVER" --geometry=49x11+200+200  -- $SHELL -c "cd ~/workspaces_nondocker/isaac_ros-dev && ros2 launch nav2_bringup r16_nav2_keepout_server_launch.py"

# KEEPOUT & /cmd_vel RELAYS
gnome-terminal --title="KEEPOUT RELAY LOCAL" --geometry=49x11+450+450  -- $SHELL -c "cd ~/workspaces_nondocker/isaac_ros-dev && ros2 run topic_tools relay /keepout_filter_mask /local_costmap/keepout_filter_mask"
gnome-terminal --title="KEEPOUT RELAY GLOBAL" --geometry=49x11+500+500  -- $SHELL -c "cd ~/workspaces_nondocker/isaac_ros-dev && ros2 run topic_tools relay /keepout_filter_mask /global_costmap/keepout_filter_mask"
gnome-terminal --title="/cmd_vel RELAY" --geometry=49x11+500+500  -- $SHELL -c "cd ~/workspaces_nondocker/isaac_ros-dev && ros2 run topic_tools relay /cmd_vel_nav /cmd_vel"

sleep 5

# NAV2 BRINGUP R16_NAVIGATION_LAUNCH - BRINGS UP... moved back to Orin 6/17/25
  # Brings up: controller_server', 'smoother_server', 'planner_server', 'behavior_server', 'bt_navigator', 'waypoint_follower', 'velocity_smoother'
# gnome-terminal --title="NAVIGATION" --geometry=49x11+300+300  -- $SHELL -c "cd ~/workspaces_nondocker/isaac_ros-dev && ros2 launch nav2_bringup r16_navigation_launch.py params_file:=/opt/ros/humble/share/nav2_bringup/params/r16_nav2_params.yaml"
# gnome-terminal --title="NAVIGATION" --geometry=49x11+300+300  -- $SHELL -c "cd ~/workspaces_nondocker/isaac_ros-dev && ros2 launch nav2_bringup r16_navigation_launch.py params_file:=/opt/ros/humble/share/nav2_bringup/params/r16_nav2_params_SmacPlannerHybrid.yaml"
# gnome-terminal --title="NAVIGATION" --geometry=49x11+300+300  -- $SHELL -c "cd ~/workspaces_nondocker/isaac_ros-dev && ros2 launch nav2_bringup r16_navigation_launch.py params_file:=/opt/ros/humble/share/nav2_bringup/params/r16_nav2_params_SmacPlannerLattice.yaml"
# experimental stuff 7/11/25+
# gnome-terminal --title="NAVIGATION NavFn" --geometry=49x11+300+300  -- $SHELL -c "cd ~/workspaces_nondocker/isaac_ros-dev && ros2 launch nav2_bringup r16_navigation_launch.py params_file:=/opt/ros/humble/share/nav2_bringup/params/r16_nav2_params_NavfnPlanner_MPPI.yaml"
# gnome-terminal --title="NAVIGATION DWB" --geometry=49x11+300+300  -- $SHELL -c "cd ~/workspaces_nondocker/isaac_ros-dev && ros2 launch nav2_bringup r16_navigation_launch.py params_file:=/opt/ros/humble/share/nav2_bringup/params/r16_nav2_params_NavfnPlanner_DWB.yaml"
#gnome-terminal --title="NAVIGATION SmacPlannerHybrid_MPPI" --geometry=49x11+300+300  -- $SHELL -c "cd ~/workspaces_nondocker/isaac_ros-dev && ros2 launch nav2_bringup r16_navigation_launch.py params_file:=/opt/ros/humble/share/nav2_bringup/params/r16_nav2_params_SmacPlannerHybrid_MPPI.yaml"
#gnome-terminal --title="NAVIGATION SmacPlanner2D_MPPI" --geometry=150x40+300+300  -- $SHELL -c "cd ~/workspaces_nondocker/isaac_ros-dev && ros2 launch nav2_bringup r16_navigation_launch.py params_file:=/opt/ros/humble/share/nav2_bringup/params/r16_nav2_params_SmacPlanner2D_MPPI.yaml"
#gnome-terminal --title="NAVIGATION NavfnPlanner DWB" --geometry=150x40+300+300  -- $SHELL -c "cd ~/workspaces_nondocker/isaac_ros-dev && ros2 launch nav2_bringup r16_navigation_launch.py params_file:=/opt/ros/humble/share/nav2_bringup/params/r16_nav2_params_NavfnPlanner_DWB.yaml"
gnome-terminal --title="NAVIGATION SmacPlanner2D_RPP" --geometry=150x40+300+300  -- $SHELL -c "cd ~/workspaces_nondocker/isaac_ros-dev && ros2 launch nav2_bringup r16_navigation_launch.py params_file:=/opt/ros/humble/share/nav2_bringup/params/r16_nav2_params_SmacPlanner2D_RPP.yaml"

# CORRECT robot_radius PARAM
# sleep 5
# gnome-terminal --title="Set global robot_radius" --geometry=49x11+0+0  -- $SHELL -c "ros2 param set /global_costmap/global_costmap robot_radius 0.30"
# gnome-terminal --title="Set local robot_radius" --geometry=49x11+0+0  -- $SHELL -c "ros2 param set /local_costmap/local_costmap robot_radius 0.30"

# TELEOP TWIST
gnome-terminal --title="TELEOP TWIST" --geometry=100x20+400+400  -- $SHELL -c "ros2 run teleop_twist_keyboard teleop_twist_keyboard"

# ECHO /cmd_vel
#gnome-terminal --title="ECHO /cmd_vel" --geometry=30x20+500+500  -- $SHELL -c "ros2 topic echo /cmd_vel"

# PLOT JUGGLER
# gnome-terminal --title="PlotJuggler" --geometry=30x20+600+600  -- $SHELL -c "ros2 run plotjuggler plotjuggler"

# SET INITIAL POSITION
sleep 15
gnome-terminal --title="SET INITIAL POSITION" --geometry=49x11+250+250  -- $SHELL -c "ros2 topic pub -1 /initialpose geometry_msgs/PoseWithCovarianceStamped '{ header: {stamp: {sec: 0, nanosec: 0}, frame_id: "map"}, pose: { pose: {position: {x: 0.0, y: 0.0, z: 0.0}, orientation: {x: 0.0, y: 0.0, z: 0.0, w: 1.0}}, } }'"

# START OLLAMA-MISTRAL MODEL
gnome-terminal --title="OLLAMA RUN MISTRAL-NEMO" --geometry=49X11+850+450  -- $SHELL -c "ollama run mistral-nemo"
# bd@R16:~$ ollama run mistral-nemo

# VUI OLLAMA BRIDGE
gnome-terminal --title="VUI OLLAMA BRIDGE" --geometry=100x30+800+400  -- $SHELL -c "ros2 run vui_ollama_bridge vui_ollama_bridge_node"

# TOPIC ECHOS
#gnome-terminal --title="/behavior_tree_log"  --geometry=60x20+0+200  -- $SHELL -c "ros2 topic echo /behavior_tree_log"
gnome-terminal --title="/voice_commands"  --geometry=40x20+0+200  -- $SHELL -c "ros2 topic echo /voice_commands"
#gnome-terminal --title="/fb_tasks"        --geometry=60x20+50+225  -- $SHELL -c "ros2 topic echo /fb_tasks"
gnome-terminal --title="/fb_speaks"       --geometry=40x20+100+250  -- $SHELL -c "ros2 topic echo /fb_speaks"
#gnome-terminal --title="/fb_requests"     --geometry=60x30+150+275  -- $SHELL -c "ros2 topic echo /fb_requests"
#gnome-terminal --title="/fb_responses"    --geometry=60x25+200+300  -- $SHELL -c "ros2 topic echo /fb_responses"
#gnome-terminal --title="/bearing_heading_turn"    --geometry=60x20+200+325  -- $SHELL -c "ros2 topic echo /bearing_heading_turn"
#gnome-terminal --title="/heading"         --geometry=60x20+200+450  -- $SHELL -c "ros2 topic echo /heading"
#gnome-terminal --title="/heading_mag_icm20948"         --geometry=60x20+200+350  -- $SHELL -c "ros2 topic echo /heading_mag_icm20948"

# LOWER FINGERS
gnome-terminal --title="LOWER FINGERS"    --geometry=60x30+200+375  -- $SHELL -c "ros2 topic pub --once /fb_requests geometry_msgs/msg/Vector3 '{x: 14.0, y: 0, z: 0}'"










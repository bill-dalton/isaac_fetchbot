cmake_minimum_required(VERSION 3.8)
project(isaac_fetchbot)

if(CMAKE_COMPILER_IS_GNUCXX OR CMAKE_CXX_COMPILER_ID MATCHES "Clang")
  add_compile_options(-Wall -Wextra -Wpedantic)
endif()

# find dependencies
find_package(ament_cmake REQUIRED)
find_package(rclcpp REQUIRED)
find_package(std_msgs REQUIRED)
find_package(behaviortree_cpp_v3 REQUIRED) # this is version 3
find_package(behaviortree_cpp REQUIRED) # this is version 4
find_package(rclcpp_action REQUIRED)
find_package(my_fetchbot_humble REQUIRED)

add_library(bt_pivot_angle_node SHARED src/bt_pivot_angle_node.cpp)
ament_target_dependencies(bt_pivot_angle_node
  rclcpp rclcpp_action behaviortree_cpp_v3 my_fetchbot_humble # this is version 3
  # rclcpp rclcpp_action behaviortree_cpp my_fetchbot_humble # this is version 4
)

install(TARGETS bt_pivot_angle_node
  LIBRARY DESTINATION lib
)
install(FILES config/pivot_bt.xml
  DESTINATION share/${PROJECT_NAME}/bt_trees
)
install(DIRECTORY launch/
  DESTINATION share/${PROJECT_NAME}/launch
)

# Add the new executable - I added this manually 5/19/25 1445PM
# add_executable(bt_pivot_angle_node src/bt_pivot_angle_node.cpp)

if(BUILD_TESTING)
  find_package(ament_lint_auto REQUIRED)
  # the following line skips the linter which checks for copyrights
  # comment the line when a copyright and license is added to all source files
  set(ament_cmake_copyright_FOUND TRUE)
  # the following line skips cpplint (only works in a git repo)
  # comment the line when this package is in a git repo and when
  # a copyright and license is added to all source files
  set(ament_cmake_cpplint_FOUND TRUE)
  ament_lint_auto_find_test_dependencies()
endif()

ament_package()

#include <behaviortree_cpp/bt_factory.h>
#include <rclcpp/rclcpp.hpp>
#include <iostream>
#include <thread>
#include <unistd.h>

int main(int argc, char **argv)
{
    rclcpp::init(argc, argv);

    std::string bt_xml = "pivot_bt.xml";
    for (int i = 1; i < argc; ++i) {
        if (std::string(argv[i]) == "--bt_xml" && i + 1 < argc) {
            bt_xml = argv[i + 1];
        }
    }

    // Ensure the XML path is absolute and points to the installed share directory
    if (!bt_xml.empty() && bt_xml[0] != '/') {
        // Use ament_index_cpp to find the installed path
        const char* ros_package_path = std::getenv("AMENT_PREFIX_PATH");
        std::string pkg_share;
        if (ros_package_path) {
            std::string prefix_path(ros_package_path);
            size_t pos = prefix_path.find(":");
            if (pos != std::string::npos) {
                prefix_path = prefix_path.substr(0, pos);
            }
            // pkg_share = prefix_path + "/share/isaac_fetchbot/bt_trees/" + bt_xml;
            pkg_share = prefix_path + "/isaac_fetchbot/share/isaac_fetchbot/bt_trees/" + bt_xml; // manually edited 5/20/25 1330PM
        } else {
            pkg_share = "./" + bt_xml;
        }
        bt_xml = pkg_share;
    }

    BT::BehaviorTreeFactory factory;
    factory.registerFromPlugin("libbt_pivot_angle_node.so");

    auto tree = factory.createTreeFromFile(bt_xml);

    while (rclcpp::ok()) {
        auto status = tree.tickWhileRunning();
        if (status == BT::NodeStatus::SUCCESS || status == BT::NodeStatus::FAILURE) {
            break;
        }
        rclcpp::spin_some(rclcpp::Node::make_shared("bt_runner_spin"));
        std::this_thread::sleep_for(std::chrono::milliseconds(10));
    }

    rclcpp::shutdown();
    return 0;
}

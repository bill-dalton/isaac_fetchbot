#include <behaviortree_cpp_v3/action_node.h>
#include <rclcpp/rclcpp.hpp>
#include <rclcpp_action/rclcpp_action.hpp>
// #include <isaac_fetchbot/PivotAngle.hpp>  // Adjust include path as needed
// #include <my_fetchbot_humble/PivotAngle.hpp>  // Adjust include path as needed
#include "my_fetchbot_humble/action/pivot_angle.hpp"  // Adjust include path as needed
#include <behaviortree_cpp_v3/bt_factory.h>

using namespace BT;

class PivotAngleAction : public SyncActionNode
{
public:
    PivotAngleAction(const std::string& name, const NodeConfiguration& config)
        : SyncActionNode(name, config)
    {
        node_ = rclcpp::Node::make_shared("bt_pivot_angle_node");
        client_ = rclcpp_action::create_client<my_fetchbot_humble::action::PivotAngle>(node_, "pivot_angle");
    }

    static PortsList providedPorts()
    {
        return { InputPort<double>("angle") };
    }

    NodeStatus tick() override
    {
        double angle;
        if (!getInput("angle", angle)) {
            throw RuntimeError("Missing required input [angle]");
        }

        if (!client_->wait_for_action_server(std::chrono::seconds(2))) {
            RCLCPP_ERROR(node_->get_logger(), "Action server not available");
            return NodeStatus::FAILURE;
        }

        auto goal_msg = my_fetchbot_humble::action::PivotAngle::Goal();
        // goal_msg.angle = angle;
        goal_msg.goal_angle = angle;

        auto future_goal = client_->async_send_goal(goal_msg);
        if (rclcpp::spin_until_future_complete(node_, future_goal) != rclcpp::FutureReturnCode::SUCCESS) {
            return NodeStatus::FAILURE;
        }
        auto goal_handle = future_goal.get();
        if (!goal_handle) return NodeStatus::FAILURE;

        auto result_future = client_->async_get_result(goal_handle);
        if (rclcpp::spin_until_future_complete(node_, result_future) != rclcpp::FutureReturnCode::SUCCESS) {
            return NodeStatus::FAILURE;
        }
        auto result = result_future.get();
        return result.result->success ? NodeStatus::SUCCESS : NodeStatus::FAILURE;
    }

private:
    rclcpp::Node::SharedPtr node_;
    std::shared_ptr<rclcpp_action::Client<my_fetchbot_humble::action::PivotAngle>> client_;
};

BT_REGISTER_NODES(factory)
{
    factory.registerNodeType<PivotAngleAction>("PivotAngle");
}

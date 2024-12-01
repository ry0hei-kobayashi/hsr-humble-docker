#!/bin/bash
set -e

source /opt/ros/humble/setup.bash --extend
source /hsr_ros2_ws/install/setup.bash --extend

# allowing access to the usb device 
exec "$@"

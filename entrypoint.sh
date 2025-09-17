#!/bin/bash
set -e

source /opt/ros/humble/setup.bash --extend
source /hsr_ros2_ws/install/setup.bash --extend

# Set Cyclone DDS
export RMW_IMPLEMENTATION=rmw_cyclonedds_cpp
export CYCLONEDDS_URI=file://$COLCON_WS_DIR/env/cyclonedds_profile.xml

# allowing access to the usb device 
exec "$@"

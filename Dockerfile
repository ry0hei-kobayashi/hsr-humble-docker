FROM osrf/ros:humble-desktop-full

LABEL maintainer="Ryohei Kobayashi <kobayashi.ryohei621@mail.kyutech.jp>"

SHELL ["/bin/bash", "-c"]
ARG DEBIAN_FRONTEND=noninteractive

RUN apt update -y
RUN apt install -y python3-colcon-common-extensions python3-rosdep
RUN rm -rf /etc/ros/rosdep/sources.list.d/20-default.list && rosdep init
RUN rosdep update

RUN mkdir -p /hsr_ros2_ws/src && cd /hsr_ros2_ws/src && \
  git clone -b humble https://github.com/hsr-project/hsrb_drivers.git && \
  git clone -b humble https://github.com/hsr-project/tmc_drivers.git && \
  git clone -b humble https://github.com/hsr-project/tmc_gazebo.git && \
  git clone -b humble https://github.com/hsr-project/hsrb_simulator.git && \
  git clone -b humble https://github.com/hsr-project/hsrb_controllers.git && \
  git clone -b humble https://github.com/hsr-project/hsrb_moveit.git && \
  git clone -b humble https://github.com/hsr-project/hsr_common.git && \
  git clone -b humble https://github.com/hsr-project/hsrb_launch.git && \
  git clone -b humble https://github.com/hsr-project/hsrb_interfaces.git && \
  git clone -b humble https://github.com/hsr-project/hsrb_common.git && \
  git clone -b humble https://github.com/hsr-project/tmc_common.git && \
  git clone -b humble https://github.com/hsr-project/tmc_common_msgs.git && \
  git clone -b humble https://github.com/hsr-project/tmc_realtime_control.git && \
  git clone -b humble https://github.com/hsr-project/hsrb_manipulation.git && \
  git clone -b humble https://github.com/hsr-project/tmc_manipulation.git && \
  git clone -b humble https://github.com/hsr-project/tmc_manipulation_base.git && \
  git clone -b humble https://github.com/hsr-project/tmc_manipulation_planner.git && \
  git clone -b humble https://github.com/hsr-project/tmc_voice.git && \
  git clone -b humble https://github.com/hsr-project/hsrb_rosnav.git && \
  git clone -b humble https://github.com/hsr-project/tmc_navigation.git && \
  git clone -b humble https://github.com/hsr-project/tmc_teleop.git && \
  git clone -b humble https://github.com/hsr-project/hsrb_teleop.git && \
  git clone -b humble https://github.com/hsr-project/tmc_database.git && \
  git clone -b ignition/humble https://github.com/ry0hei-kobayashi/tmc_wrs_gazebo.git && \
  rm -rf hsrb_launch/hsrb_robot_launch && \
  rm -rf hsrb_gazebo_launch/tmc_grid_map_server && \
  rm -rf hsrb_simulator/hsrb_rviz_simulator && \
  rm -rf tmc_drivers/tmc_pgr_camera

RUN cd /hsr_ros2_ws && . /opt/ros/humble/setup.bash && rosdep install --ignore-src -r -y -i --from-paths src && \
    #--skip-keys="tmc_odometry_switcher" && \
    colcon build --symlink-install --cmake-args -DCMAKE_BUILD_TYPE=Release --parallel-workers $(nproc)

RUN apt update -y
RUN apt install -y vim \
    ros-humble-rmw-cyclonedds-cpp

# additional packages
COPY additional_packages  /hsr_ros2_ws/src/additional_packages/
RUN cd /hsr_ros2_ws && . /opt/ros/humble/setup.bash && . /hsr_ros2_ws/install/setup.bash && \
    rosdep install --ignore-src -r -y -i --from-paths src && \
    colcon build --symlink-install --cmake-args -DCMAKE_BUILD_TYPE=Release --parallel-workers $(nproc)

RUN . /opt/ros/humble/setup.bash && . /hsr_ros2_ws/install/setup.bash
COPY ./cyclonedds_profile.xml /hsr_ros2_ws/cyclonedds_profile.xml
COPY ./entrypoint.sh /hsr_ros2_ws/entrypoint.sh
RUN chmod +x /hsr_ros2_ws/entrypoint.sh
ENTRYPOINT ["/hsr_ros2_ws/entrypoint.sh"]

WORKDIR /hsr_ros2_ws

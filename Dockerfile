FROM osrf/ros:humble-desktop-full

SHELL ["/bin/bash", "-c"]
ARG DEBIAN_FRONTEND=noninteractive

RUN apt update -y
RUN apt install -y python3-colcon-common-extensions python3-rosdep
RUN rm -rf /etc/ros/rosdep/sources.list.d/20-default.list && rosdep init
RUN rosdep update

RUN mkdir -p /hsr_ros2_ws/src && cd /hsr_ros2_ws/src && \
  git clone -b humble https://github.com/hsr-project/gazebo_ros2_control.git && \
  git clone -b humble https://github.com/hsr-project/hsrb_controllers.git && \
  git clone -b humble https://github.com/hsr-project/hsrb_description.git && \
  git clone -b humble https://github.com/hsr-project/hsrb_drivers.git && \
  git clone -b humble https://github.com/hsr-project/hsrb_launch.git && \
  git clone -b humble https://github.com/hsr-project/hsrb_manipulation.git && \
  git clone -b humble https://github.com/hsr-project/hsrb_meshes.git && \
  git clone -b humble https://github.com/hsr-project/hsrb_rosnav.git && \
  git clone -b humble https://github.com/hsr-project/hsrb_simulator.git && \
  git clone -b humble https://github.com/hsr-project/hsrb_teleop.git && \
  git clone -b humble https://github.com/hsr-project/tmc_gazebo.git && \
  git clone -b humble https://github.com/hsr-project/tmc_common.git && \
  git clone -b humble https://github.com/hsr-project/tmc_common_msgs.git && \
  git clone -b humble https://github.com/hsr-project/tmc_database.git && \
  git clone -b humble https://github.com/hsr-project/tmc_manipulation.git && \
  git clone -b humble https://github.com/hsr-project/tmc_manipulation_base.git && \
  git clone -b humble https://github.com/hsr-project/tmc_manipulation_planner.git && \
  git clone -b humble https://github.com/hsr-project/tmc_realtime_control.git && \
  git clone -b humble https://github.com/hsr-project/tmc_voice.git && \
  rm -rf hsrb_launch/hsrb_robot_launch

RUN cd /hsr_ros2_ws && . /opt/ros/humble/setup.bash && rosdep install --from-paths . -y --ignore-src && colcon build --symlink-install --cmake-args -DCMAKE_BUILD_TYPE=Release --parallel-workers $(nproc)

RUN . /opt/ros/humble/setup.bash && . /hsr_ros2_ws/install/setup.bash
COPY ./entrypoint.sh /hsr_ros2_ws/entrypoint.sh
RUN chmod +x /hsr_ros2_ws/entrypoint.sh
ENTRYPOINT ["/hsr_ros2_ws/entrypoint.sh"]

WORKDIR /hsr_ros2_ws

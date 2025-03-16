#! /bin/bash

source /home/pi/oradar_ws/devel/setup.bash

gnome-terminal -x bash -c "roslaunch laser_test wheelchair.launch"
wait
exit 0

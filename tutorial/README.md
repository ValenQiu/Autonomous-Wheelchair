# Autonomous Wheelchair Quick Deployment Guide

## Lidar Preparation
<details open>

<summary>View details</summary>

### Install the Oradar Lidar Driver

To install the Oradar Lidar driver, navigate to the [`src`](../src) directory, then go to the [`oradar_ros`](../src/oradar_ros/) folder[^1]. Open a terminal in this folder and run the following commands:

```bash
mkdir build
cd build
cmake ..
make -j4
sudo make install
```

### Setup the Device Name of Oradar Lidars

Since this project uses multiple radars, you need to specify the serial port mapping for each radar. First, connect the devices, open a terminal, and enter:

```bash
ll /dev/ttyACM*
```

This command will list all serial devices of the ACM class, as shown below:

```bash
crwxrwxrwx 1 root dialout 166, 0 Jan  3 16:47 /dev/ttyACM0
crwxrwxrwx 1 root dialout 166, 1 Jan  3 16:47 /dev/ttyACM1
crw-rw---- 1 root dialout 166, 2 Jan  3 17:24 /dev/ttyACM2
```

Next, check the port number of the serial device by entering:

```bash
udevadm info -a --name=/dev/ttyACM0 | grep devpath
```

This will return:

```bash
    ATTRS{devpath}=="3"
    ATTRS{devpath}=="0"
```

This indicates that the port number of the device `/dev/ttyACM0` is 3. Check the numbers for the other devices similarly. Then, navigate to the [`oradar_ros`](../src/oradar_ros/) folder, open the [`oradar.rules`](../src/oradar_ros/oradar.rules) mapping file, and modify its content as follows:

```bash
KERNEL=="ttyACM*", ATTRS{devpath}=="2", ATTRS{idVendor}=="1a86", ATTRS{idProduct}=="55d4", MODE:="0777", SYMLINK+="oradar1"
KERNEL=="ttyACM*", ATTRS{devpath}=="3", ATTRS{idVendor}=="1a86", ATTRS{idProduct}=="55d4", MODE:="0777", SYMLINK+="oradar2"
KERNEL=="ttyACM*", ATTRS{devpath}=="1", ATTRS{idVendor}=="1a86", ATTRS{idProduct}=="55d4", MODE:="0777", SYMLINK+="oradar3"
```

This configuration specifies that the port type is `ttyACM`, assigns `ATTRS{devpath}` to the corresponding port, and maps the device to `SYMLINK+`.

### Installing the Mapping File

Open a terminal, navigate to the location of the `oradar.rules` file, and enter:

```bash
sudo cp oradar.rules /etc/udev/rules.d/
```

Then, verify the mapping by entering:

```bash
ll /dev/oradar1
```

This should return:

```bash
lrwxrwxrwx 1 root root 7 Jan  3 16:47 /dev/oradar1 -> ttyACM0
```

Repeat this for the other devices (`oradar2` and `oradar3`) to view their port numbers.

#### Reference
[^1] YahBoom MS200 Lidar Repository: http://www.yahboom.net/study/MS200

> Serial Port Binding: [`pdf`](../Supplements/Oradar%20Lidar/2、语音控制模块端口绑定.pdf)

</details>

## Start the ROS Program Automatically at Boot

<details>

<summary>View details</summary>

Reference: [CSDN Article](https://blog.csdn.net/qq_46227775/article/details/118657435)

### Create a New Script to Start the Program at Startup

Create a script named [`m.sh`](../src/auto_wheelchair/m.sh) with the following content:

```bash
#! /bin/bash

source /home/pi/oradar_ws/devel/setup.bash

gnome-terminal -x bash -c "roslaunch laser_test wheelchair.launch"
wait
exit 0
```

### Grant Script Permissions

Navigate to the folder containing the script, open a terminal, and run:

```bash
sudo chmod 777 m.sh
```

### Add Autostart Script

In the terminal, enter:

```bash
gnome-session-properties
```

Then add the `m.sh` file you just edited in the pop-up window, restart, and test whether the boot-up self-start is successful.

</details>
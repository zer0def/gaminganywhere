Building on Ubuntu 16.04 64 bit and AWS June 12, 2019 by Darsh Lin

These are the instructions to install GamingAnywhere on Ubuntu 16.04 64 bit and running AssaultCube v1.2.0.2. These instructions have been completed on April 16, 2019. Versions of both GamingAnywhere and AssaultCube may change with time and Ubuntu versions may get decommissioned. Change instructions depending on versions.
sudo apt update
sudo apt install libxext6 libxext-dev libxtst6 libxtst-dev libfreetype6 libfreetype6-dev libogg-dev yasm nasm libx11-dev mesa-utils libpulse-dev libasound2-dev  libxtst-dev libswscale-dev libpostproc-dev libavdevice-dev libavfilter-dev libavcodec-dev libavformat-dev libsdl2-dev libsdl2-ttf-dev libopus-dev cmake ffmpeg git libx265-dev libsdl-image1.2 vim
Create directory“myprog”
mkdir myprog 
cd myprog
Get the source code from git:
git clone https://github.com/chunying/gaminganywhere.git
sudo apt update
sudo apt-get install -y patch make cmake g++ pkg-config libx11-dev libxext-dev libxtst-dev libfreetype6-dev libgl1-mesa-dev libglu1-mesa-dev libpulse-dev libasound2-dev lib32z1
cd gaminganywhere
source env-setup
cd deps.src
sudo make
sudo chmod 777 /etc/ld.so.conf
export LD_LIBRARY_PATH="$HOME/myprog/gaminganywhere/deps.posix/lib"
sudo echo "$HOME/myprog/gaminganywhere/deps.posix/lib" >> /etc/ld.so.conf
sudo ldconfig
cd .. /ga
make all
make install
Download assaultcube via https://assault.cubers.net/download.html
Follow these instructions to install it only from terminal. Be sure to go back to your root directory by typing “cd”
sudo apt-get install libsdl1.2debian libsdl-image1.2 zlib1g libogg0 libvorbis0a libopenal1 libcurl3
wget wget http://netcologne.dl.sourceforge.net/project/actiongame/AssaultCube%20Version%201.2.0.2/AssaultCube_v1.2.0.2.tar.bz2
tar -xjvf AssaultCube_v1.2.0.2.tar.bz2
Find the config file for the game you need and correct the file paths so an example using AssaultCube in server.assaultcube.linux.conf
Located in $HOME/myprog//gaminganywhere/bin/config
[ga-server-event-driven]
game-dir = /home/ubuntu/AssaultCube_v1.2.0.2
game-exe = /home/ubuntu/AssaultCube_v1.2.0.2/bin_unix/linux_64_client
game-argv[1] = --home=/home/ubuntu/.assaultcube_v1.2
game-argv[2] = --init
/home/ubuntu is the root directory or $HOME
Run on AWS: 1604 & AssaultCube
Create an ec2 instance with a GPU and follow the instructions to install gaminganywhere above.
Install a gui and a way to access it using the following instructions from this link:
http://sequentropy.com/2018/04/07/tutorial-connecting-to-aws-ec2-ubuntu-desktop/
sudo -s
sudo apt update && sudo apt upgrade
sudo apt install ubuntu-desktop
sudo apt install vnc4server
sudo apt install gnome-panel
sudo vncserver (To test)
sudo vncserver -kill :1
sudo vim .vnc/xstartup
The bottom part of this file should look like:




#!/bin/sh


# Uncomment the following two lines for normal desktop:


unset SESSION_MANAGER


# exec /etc/X11/xinit/xinitrc


gnome-session –session=gnome-classic &


gnome-panel&
sudo vncserver (To run)
Install tightvnc onto your windows machine
Open TightVNC Viewer
Put in the IP address of your AWS instance and the port 5901
Eg 12.345.6.78::5901
Should work now
You can just disable the audio on the same config file as assault cube (server.assaultcube.linux.conf) by making enable-audio = false. If you want audio, follow below steps:
Install new kernel that has sound card enabled
sudo apt install linux-generic
sudo grub-set-default "Advanced options for Ubuntu>Ubuntu, with Linux 4.4.0-146-generic"
sudo update-grub
If the audio fails to init do the following commands
sudo modprobe snd-aloop
alsa force-reload
ga-client.exe config\client.rel.conf rtsp://publicIP:8554/desktop

To run:
Server
./ga-server-event-driven config/server.assaultcube.linux.conf
Client
./ga-client config/client.rel.conf rtsp://192.168.***.***:8000/desktop
The ip address will be whatever your ifconfig or ipconfig shows.


Work on 5/29:

Installed graphics driver according to:
https://docs.aws.amazon.com/AWSEC2/latest/UserGuide/install-nvidia-driver.html

Current work on 6/1:
Fixed the stalling! 
In Server:
~/gaminganywhere/bin/config/common/server-common.conf:
Change proto = udp to proto =tcp
In Client:
In the client config so for example ~/gaminganywhere/bin/config/client.abs.conf
Add proto = tcp under the [core] section



GamingAnywhere
==============

GamingAnywhere: An Open Cloud Gaming System

# Overview

GamingAnywhere is an open-source clouding gaming platform. In addition to its
openness, we design GamingAnywhere for high extensibility, portability, and
reconfigurability. GamingAnywhere currently supports Windows and Linux, and
can be ported to other OS's including OS X and Android.

# Documents

* Official web site: http://gaminganywhere.org/

* Quick start guide: http://gaminganywhere.org/doc/quick_start.html

* Configuration file guide: http://gaminganywhere.org/doc/config.html

* FAQ: http://gaminganywhere.org/faq.html

# Quick Notes

* Recommended development platforms Ubuntu Linux x86_64.

* Required packages on Linux OS (both runtime and development files):
```libx11```, ```libxext```, ```libxtst```, ```libfreetype6```,
```libgl1-mesa```, ```libglu1-mesa```, ```libpulse```,
```libasound2```, ```lib32z1```

* Sample command to install required packages on Ubuntu Linux:
  ```
  apt-get  install patch make cmake g++ pkg-config \
		libx11-dev libxext-dev libxtst-dev libfreetype6-dev \
		libgl1-mesa-dev libglu1-mesa-dev \
		libpulse-dev libasound2-dev lib32z1
  ```

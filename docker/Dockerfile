# 12/sep/2017

from ubuntu:16.04

MAINTAINER hradec <hradec@hradec.com>

ENV TERM="xterm-256color"

# install needed packages
RUN apt update
RUN apt  install -y libxext6 libxext-dev libxtst6 libxtst-dev libfreetype6 libfreetype6-dev libogg-dev yasm nasm libx11-dev mesa-utils libpulse-dev libasound2-dev  libxtst-dev libswscale-dev libpostproc-dev libavdevice-dev libavfilter-dev libavcodec-dev libavformat-dev libsdl2-dev libsdl2-ttf-dev libopus-dev cmake ffmpeg git libx265-dev libsdl-image1.2 vim
RUN apt  install -y patch make cmake g++ pkg-config libx11-dev libxext-dev libxtst-dev libfreetype6-dev libgl1-mesa-dev libglu1-mesa-dev libpulse-dev libasound2-dev lib32z1

# build
#RUN 	cd /root ;  \
#	git clone https://github.com/chunying/gaminganywhere.git

RUN apt install -y sudo

ENV SHELL=/bin/bash
RUN	echo "#!/bin/bash\n\n\
	export HOME=/root/ ;\
	cd /root/gaminganywhere ;\
	. ./env-setup ;\
	cd deps.src ;\
	make -j $(grep MHz /proc/cpuinfo  | wc -l) GADEPS=/root/gaminganywhere/deps.posix/lib  ;\
	chmod 777 /etc/ld.so.conf ;\
	export LD_LIBRARY_PATH='/root/gaminganywhere/deps.posix/lib' ;\
	echo '/root/gaminganywhere/deps.posix/lib' >> /etc/ld.so.conf ;\
	ldconfig ;\
" > /root/make.sh


RUN	echo "\n\n\
	cd /root/gaminganywhere/ga ;\
	export LD_LIBRARY_PATH='/root/gaminganywhere/deps.posix/lib' ;\
	make all -j $(grep MHz /proc/cpuinfo  | wc -l) ;\
	make install ;\
" >> /root/make.sh

RUN chmod a+x /root/make.sh
RUN cat /root/make.sh

USER root
CMD [ "/root/make.sh" ]

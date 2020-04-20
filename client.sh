#!/bin/bash

CD=$(dirname $(readlink -f $BASH_SOURCE))
cd $CD/bin

LD_LIBRARY_PATH=$(pwd)/../deps.posix/lib/lib/ ./ga-client config/client.rel.conf rtsp://$1/desktop

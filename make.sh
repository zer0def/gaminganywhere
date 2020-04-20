#!/bin/bash

CD=$(dirname $(readlink -f $BASH_SOURCE))
cd $CD
. $CD/env-setup
cd $CD/docker
./run.sh



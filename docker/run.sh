#!/bin/bash

CD=$(dirname $(readlink -f $BASH_SOURCE))

docker rm -f ga 
docker build . -t hradec/ga && \
docker run --rm --name ga -v $CD/../:/root/gaminganywhere/ hradec/ga

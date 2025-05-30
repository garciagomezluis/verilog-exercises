#!/bin/bash

set -e

mkdir -p tmp
xhost +local:docker &> /dev/null
docker run --rm -it \
  -e DISPLAY=$DISPLAY \
  -u $(id -u):$(id -g) \
  -v /tmp/.X11-unix:/tmp/.X11-unix \
  -v "$(pwd)/tmp":/workspace/tmp \
  -v "$(pwd)/src":/workspace/src \
  -v "$(pwd)/container/Makefile":/workspace/Makefile \
  -w /workspace \
  fpga-env "$@"
xhost -local:docker &> /dev/null

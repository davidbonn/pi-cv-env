#!/bin/bash

#
# this script is used to take an original raspberry pi debian buster image
# and make it ready for running as a computer vision appliance
#
# most of this is stuff you need to run opencv and scikit-learn and other
# python components
#
cd $HOME

sudo apt-get upgrade
sudo apt-get update

# for python builds
sudo apt-get install -y make build-essential libssl-dev zlib1g-dev \
libbz2-dev libreadline-dev libsqlite3-dev wget curl llvm libncurses5-dev \
libncursesw5-dev xz-utils tk-dev libffi-dev liblzma-dev

# some other things we need
sudo apt-get install -y git cu cmake gfortran \
libblas-dev libopenblas-base libatlas-base-dev

sudo apt-get install -y build-essential pkg-config
sudo apt-get install -y libjpeg-dev libtiff5-dev libjasper-dev libpng-dev
sudo apt-get install -y libavcodec-dev libavformat-dev libswscale-dev libv4l-dev
sudo apt-get install -y libxvidcore-dev libx264-dev

sudo apt-get install -y libfontconfig1-dev libcairo2-dev
sudo apt-get install -y libgdk-pixbuf2.0-dev libpango1.0-dev
sudo apt-get install -y libgtk2.0-dev libgtk-3-dev

sudo apt-get install -y python-dev libuvc-dev

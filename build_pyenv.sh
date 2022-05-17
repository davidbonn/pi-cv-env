#!/bin/bash

# build pyenv
# tweak .bashrc
# install python 3.9.6
# make virtual environment for deepseek
# install all packages for deepseek

if [ -d $HOME/.pyenv ]; then
  exit 0
fi

# eventually command-line switches
PYTHON_VERSION=3.9.6
VENV=opencv

curl https://pyenv.run | bash

cat pyenv-proto >>$HOME/.bashrc

hash -r

. pyenv-proto

hash -r

pyenv install $PYTHON_VERSION
pyenv virtualenv $PYTHON_VERSION $VENV

pyenv global $VENV
pip install --upgrade pip

# might need more swap space here too...
sudo sysctl vm.swappiness=100

# need this for picamera installation for some reason
export READTHEDOCS=True

pip install wheel
pip install -r requirements.txt

# need to do this goofiness because of bugs in opencv builds
pip3 install git+https://github.com/opencv/opencv-python

pip install tflite_runtime

sudo sysctl vm.swappiness=60

pyenv rehash

pip freeze >$HOME/frozen.txt

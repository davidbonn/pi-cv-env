#!/bin/bash

#
# example startup script to use in pi-cv-env, intended to be
# run as user 'pi'
#

export TERM=linux
export LOGNAME=pi
export HOME=/home/pi
export LANGUAGE=en_US.UTF-8
export LANG=en_US.UTF-8
export PATH=/bin:/usr/bin:/usr/local/bin

export PYTHONDONTWRITEBYTECODE=yes
export PYTHONUNBUFFERED=1
export PYTHONPATH=/home/pi

cd $HOME

export PYENV_ROOT="$HOME/.pyenv"
command -v pyenv >/dev/null || export PATH="$PYENV_ROOT/bin:$PATH"
eval "$(pyenv init - --no-rehash)"
eval "$(pyenv virtualenv-init -)"

python3 ./my-script.py --verbose &


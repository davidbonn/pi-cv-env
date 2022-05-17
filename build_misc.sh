#!/bin/bash

#
# fill in miscellaneous things we need to do
#

sudo touch /boot/ssh

mkdir $HOME/bin
chmod 755 $HOME/bin
install -m 755 *.py $HOME/bin

# install rc.local
(cd configs; sudo install -m 755 rc.local /etc)

# force to GMT
sudo timedatectl set-timezone UTC

# turn off daily update and upgrade services

sudo systemctl disable apt-daily.service
sudo systemctl disable apt-daily.timer

sudo systemctl disable apt-daily-upgrade.timer
sudo systemctl disable apt-daily-upgrade.service

# tag /etc/motd
sudo  bash -c 'echo "" >>/etc/motd'
sudo  bash -c 'echo "Modified for Pi Computer Vision Environment" >> /etc/motd'

#


#!/bin/bash

#
# makes a pi boot image readonly per this document:
#   https://medium.com/swlh/make-your-raspberry-pi-file-system-read-only-raspbian-buster-c558694de79
#

if [ -f /etc/READONLY ]
then
  echo "Already readonly, you are kind of screwed."
  exit 1
fi

# add packages and remove packages
sudo apt-get update -y
sudo apt-get upgrade -y

sudo apt-get remove -y --purge triggerhappy logrotate dphys-swapfile

sudo apt-get autoremove -y

#
# add "fastboot noswap ro" to /boot/cmdline.txt
#
sudo python3 ./ro_helper.py --replace fix-cmdline
sudo chmod 755 /boot/cmdline.txt

#
# replace rsyslogd with busybox-syslogd
#
sudo apt-get install -y busybox-syslogd
sudo apt-get remove -y --purge rsyslog

#
# ?make file systems readonly in /etc/fstab
# and add temp filesystems
#
# fstab entries should look like this:
#proc                  /proc     proc    defaults             0     0
#PARTUUID=xxxxxxxx-01  /boot     vfat    defaults,ro          0     2
#PARTUUID=xxxxxxxx-02  /         ext4    defaults,noatime,ro  0     1
#
sudo python3 ./ro_helper.py --replace fix-fstab
sudo chmod 644 /etc/fstab

#
# and these entries should be added at the end of /etc/fstab:
#
sudo bash -c 'cat - >>/etc/fstab' <<END
tmpfs        /tmp            tmpfs   nosuid,nodev         0       0
tmpfs        /var/log        tmpfs   nosuid,nodev         0       0
tmpfs        /var/tmp        tmpfs   nosuid,nodev         0       0
END

# move some system files to /tmp:
sudo rm -rf /var/lib/dhcp /var/lib/dhcpcd5 /var/spool /etc/resolv.conf
sudo ln -s /tmp /var/lib/dhcp
sudo ln -s /tmp /var/lib/dhcpcd5
sudo ln -s /tmp /var/spool
sudo touch /tmp/dhcpcd.resolv.conf
sudo ln -s /tmp/dhcpcd.resolv.conf /etc/resolv.conf

# update systemd random seed:
#
sudo rm /var/lib/systemd/random-seed
sudo ln -s /tmp/random-seed /var/lib/systemd/random-seed
#
# add line to /lib/systemd/system/systemd-random-seed.service,
# under the service section
#ExecStartPre=/bin/echo "" >/tmp/random-seed
#
sudo python3 ./ro_helper.py --replace fix-random-seed
sudo chmod 644 /lib/systemd/system/systemd-random-seed.service

#
# add some helpful commands
#
sudo bash -c 'cat - >>/etc/bash.bashrc' <<END

# ro/rw aliases
alias ro='sudo mount -o remount,ro / ; sudo mount -o remount,ro /boot'
alias rw='sudo mount -o remount,rw / ; sudo mount -o remount,rw /boot'

END

#
# reset readonly when we log out
#
sudo bash -c 'cat - >/etc/bash.bash_logout' <<END
sudo mount -o remount,ro /
sudo mount -o remount,ro /boot
END

# turn off timesync, recommend chrony if you need timesync
sudo systemctl disable systemd-timesyncd.service

# turn off fake hwclock
sudo systemctl disable fake-hwclock.service

sudo touch /etc/READONLY

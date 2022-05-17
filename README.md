# Pi Base

Scripts and artifacts used to build the base raspberry pi environment

## What's here

* Scripts to make a Pi Base (starting from a Raspbian Buster Headless) implementation.
* Some system config files we must install.

## Parts list

* `configs` -- system config files to install
* `examples` -- example program directory
* `initialize.sh` -- installs *apt* packages we need, well most of them
* `build_pyenv.sh` -- installs *pyenv*, python 3.9.6 and packages to make *deepseek* virtual environment
* `build_misc.py` -- fixes up various things needing fixing
* `make_readonly.sh` -- builds a readonly filesystem on top of this all
* `ro_helper.py` -- helper script called by `make_readonly.py`
* `mk_pi_base.sh` -- builds pi_base.tar.gz to be marshalled to new pi

## Commands to run.

First, set swap space to 2048MB in `/etc/dphys-swapfile`.  You need to do that manually.


Upload `pi_base.tar.gz` to `/home/pi`.  Use `mk_pi_base.sh` to make
`pi_base.tar.gz`.

ssh to your pi and untar `pi_base.tar.gz` in `/home/pi`

Run the following:
1. `bash ./initialize.sh`
2. `bash ./build_pyenv.sh`
3. `bash ./build_misc.sh`
4. `bash ./make_readonly.sh`

Both #1 and #2 take quite a while.

Then cross your fingers and reboot.

There is also an `everything.sh` script that runs the above, use it if you
are brave.  Takes a little over four hours on a 1GB Pi4.

## Stuff not here

I downloaded the starter image from https://www.raspberrypi.com/software/operating-systems/ , in particular I grabbed the "Raspberry Pi OS Lite (Legacy) Release date: April 4th 2022" image, approximately 284MB in size.

Make sure when after you flash you make an empty file called `ssh` and create a proper `wpa_supplicant.conf`
in the flash drive boot partition.

Setting swap space extra large (preferably to 2048MB) before running builds below.  Might work fine on a 4GB Pi4 without it.  Change swap space in `/etc/dphys-swapfile`.

Downloads sometimes time out.  It sucks.

Checking to make sure you are starting from Rasbian Buster (32-bit).

Probably want to run pishrink on the resultant SD card image afterwards to fit in the smallest possible SD card.

I'd like to factor a lot of this out so I can open source some of the scripts.

On `pyenv`.  If you add more packages you'll need to sometimes do a `pyenv rehash` manually since we are typically running readonly.  Best to explicitly do it after adding packages.

## Example wpa_supplicant.conf

Here is an example `wpa_supplicant.conf`.

```
country=US
ctrl_interface=DIR=/var/run/wpa_supplicant GROUP=netdev
update_config=1

network={
    ssid="chewuch.tv"
    psk="password"
}
```


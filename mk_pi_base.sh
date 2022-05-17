#!/bin/sh

#
# intended to run on machine with sources and not a pi
#

chmod 755 *.sh
tar cvfz ../pi_base.tar.gz ./artifacts ./configs *.sh *.txt *.py *.md pyenv-proto




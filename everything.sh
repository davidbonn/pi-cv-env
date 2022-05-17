#!/bin/bash

bash ./initialize.sh
bash ./build_pyenv.sh
bash ./build_misc.sh

bash ./make_readonly.sh

echo
echo "All installed.  Reboot.  And pray."
echo

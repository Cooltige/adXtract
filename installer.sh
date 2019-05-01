#!/bin/bash
CWD="$(pwd)"
sudo apt-get install libesedb-dev
printf "\033c"
echo "Configuration has completed"
echo "run adXtract.sh /pathto/ntds.dit /pathto/SYSTEM /ProjectName"


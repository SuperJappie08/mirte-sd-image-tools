#!/bin/bash

# this depends on the host system used
# sudo apt install apptainer

sudo rm -rf image_tools.sif
sudo apptainer build image_tools.sif image_tools.def

sudo cp image_tools.sif image_tools.backup.sif
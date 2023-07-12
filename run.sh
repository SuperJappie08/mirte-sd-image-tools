#!/bin/bash

exec > >(tee -a "logs.log") 2>&1

# Ask for sudo password once, and make sure the timeout will
# not expire.
#sudo -v
#while true; do
#   sudo -nv; sleep 1m
#   kill -0 $$ 2>/dev/null || exit
#done &

if test "$1" == "image_shell"; then
  # Shell into the SD card image. This means mounting the the image
  # and chroot 'into' the image.
  sudo apptainer run --app load_image --bind ./mirte_${2}_sd.img:/mirte_sd.img image_tools.sif
fi
if test "$1" == "apptainer_shell"; then
  #TODO: also bind the repos.yaml and git_local?
  sudo apptainer shell --bind ./mirte_${2}_sd.img:/mirte_sd.img image_tools.sif
fi
if test "$1" == "build_sd_image"; then
  # Determine which image to build
  image="orangepi"
  if [ $2 ]; then
    image=$2
  fi

  # Download and resize the image to 8Gb
  if [ ! -f ./mirte_${image}_sd.img ]; then
    # only when it not already exists
    ./scripts/download_image.sh $image
    # apptainer run --app download_image image_tools.sif $image
  fi

  # make a duplicate to work on
  if [ -f ./mirte_${image}_sd_wip.img ]; then
    sudo rm ./mirte_${image}_sd_wip.img
  fi
  if [ $3 ] && [ -f ./mirte_vlatest_${image}_sd.img ] ; then # if incremental, use latest to do all actions on
  echo "Incremental"
    sudo cp ./mirte_vlatest_${image}_sd.img ./mirte_${image}_sd_wip.img
    echo "Done copy"
  else
        sudo cp ./mirte_${image}_sd.img ./mirte_${image}_sd_wip.img

  fi
  sudo apptainer run --app prepare_image --bind ./mirte_${image}_sd_wip.img:/mirte_sd.img image_tools.sif

  # Install mirte on the image
  if [ -f ./repos.yaml ] && [ -d ./git_local ]; then
    sudo apptainer run --app install_mirte --bind ./mirte_${image}_sd_wip.img:/mirte_sd.img --bind ./repos.yaml:/repos.yaml --bind ./git_local:/git_local image_tools.sif
  elif [ -f ./repos.yaml ]; then
    sudo apptainer run --app install_mirte --bind ./mirte_${image}_sd_wip.img:/mirte_sd.img --bind ./repos.yaml:/repos.yaml image_tools.sif
  elif [ -d ./git_local ]; then
    sudo apptainer run --app install_mirte --bind ./mirte_${image}_sd_wip.img:/mirte_sd.img --bind ./git_local:/git_local image_tools.sif
  else
    sudo apptainer run --app install_mirte --bind ./mirte_${image}_sd_wip.img:/mirte_sd.img image_tools.sif
  fi

# duplicate for next incremental build
cp ./mirte_${image}_sd_wip.img ./mirte_vlatest_${image}_sd.img 

  # Shrink the image to max used size and zip it for convenience
  sudo apptainer run --app shrink_image --bind ./mirte_${image}_sd_wip.img:/mirte_sd.img image_tools.sif
  
  filename=mirte_v$(date +"%Y%m%d%T")_${image}_sd.img
  mv ./mirte_${image}_sd_wip.img ./"${filename}"
  xz -vT6 ./"${filename}"
fi

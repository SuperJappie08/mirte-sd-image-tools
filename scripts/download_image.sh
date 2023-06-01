#!/bin/sh

raspberry_pi_link="https://cdimage.ubuntu.com/releases/20.04.5/release/ubuntu-20.04.5-preinstalled-server-armhf+raspi.img.xz"
orange_pi_link="https://archive.armbian.com/orangepizero/archive/Armbian_21.02.3_Orangepizero_focal_current_5.10.21.img.xz"
orange_pi2_link="https://archive.armbian.com/orangepizero2/archive/Armbian_22.02.2_Orangepizero2_focal_legacy_4.9.255.img.xz"

image="custom"
if [ "$1" = "" ] || [ "$1" = "orangepi" ]; then
   image="orangepi"
elif [ "$1" = "orangepi2" ]; then
   image="orangepi2"
elif [ "$1" = "raspberrypi" ]; then
   image="raspberrypi"
fi

image_link=$orange_pi_link
if [ "$image" = "orangepi2" ]; then
   image_link=$orange_pi2_link
elif [ "$image" = "raspberrypi" ]; then
   image_link=$raspberry_pi_link
fi

if [ "$image" = "custom" ]; then
   cp $1 mirte_custom_sd.img
else
   # Download and unxz the file
   # TODO:aks for permission to overwrite
   if [ -f mirte_${image}_sd.img ]; then
    echo "Image already exists"
    exit 0
   fi
   wget -O mirte_${image}_sd.img.xz $image_link
   rm -f mirte_${image}_sd.img
   unxz mirte_${image}_sd.img.xz
fi

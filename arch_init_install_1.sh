#!/bin/bash

echo make sure you have already connect to internet 
sleep 10
# after set network, we update mirror 
reflector -c AU -a 6 --sort rate --save /etc/pacman.d/mirrorlist
# update system lock
timedatectl set-ntp true

lsblk

echo now please input the disk you want to partition
read myparitiondisk
uefipartition="${myparitiondisk}p1"
swappartition="${myparitiondisk}p2"
rootpartition="${myparitiondisk}p3"
homepartition="${myparitiondisk}p4"

# ----------------- setup partition -----------------------------
(echo g; echo n; echo ""; echo ""; echo +500M; echo N; echo t; echo uefi;\
echo n; echo ""; echo ""; echo +32G; echo t; echo ""; echo swap;\
echo n; echo ""; echo ""; echo +180G; echo t; echo ""; echo 23;\
echo n; echo ""; echo ""; echo ""; echo t; echo ""; echo home;\
echo w) | fdisk /dev/$myparitiondisk

#--------------------format partition ------------------------------ 
mkfs.fat /dev/$uefipartition
mkfs.ext4 /dev/$rootpartition
mkfs.ext4 /dev/$homepartition
mkswap /dev/$swappartition

# ----------------- mount just paritioned ------------------------
mount /dev/$rootpartition /mnt
mkdir /mnt/boot
mkdir /mnt/home
mount /dev/$uefipartition /mnt/boot
mount /dev/$homepartition /mnt/home
swapon /dev/$swappartition
# ---------------------------------------------------------------- 

# ---------------- install packages ---------------------------------

pacstrap /mnt base linux linux-firmware base-devel linux-headers git

# fstab file generation
genfstab -U /mnt >> /mnt/etc/fstab

# ending 
echo now you need to arch-chroot mnt and do the next stuff thx 


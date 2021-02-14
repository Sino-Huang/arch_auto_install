#!/bin/bash

#-------------- after archroot change ---------------------------------

# generate time zone and timeset
ln -sf /usr/share/zoneinfo/Australia/Canberra /etc/localtime
hwclock -w

# - ------------------localisation-----------------------------
sed -ie "s/^#\s*\(en_US\.UTF-8\)/\1/" /etc/locale.gen
sed -ie "s/^#\s*\(en_AU\.UTF-8\)/\1/" /etc/locale.gen
sed -ie "s/^#\s*\(zh_CN\.UTF-8\)/\1/" /etc/locale.gen
sed -ie "s/^#\s*\(zh_CN\.GB18030\)/\1/" /etc/locale.gen
# ------------------------------------------------------------

locale-gen
echo LANG=en_AU.UTF-8 > /etc/locale.conf
# ------------------------------------------------------------
echo input your hostname please
read myhostname

echo $myhostname > /etc/hostname
cat >>/etc/hosts <<EOL
127.0.0.1	localhost
::1		localhost
127.0.1.1	$myhostname.localdomain	$myhostname
EOL

echo input your root password please
passwd

pacman -Sy --noconfirm amd-ucode grub efibootmgr os-prober rsync neovim ranger neofetch htop man-db man-pages networkmanager ntfs-3g
pacman -S --noconfirm nvidia-dkms nvidia-utils cuda-tools xorg sddm plasma kde-applications packagekit-qt5 reflector nvidia-settings mesa mesa-demo

useradd -m -G wheel sukai
echo input your user password please
passwd sukai

# ------------ bootloader -----------
grub-install --target=x86_64-efi --efi-directory=/boot --bootloader-id=GRUB
grub-mkconfig -o /boot/grub/grub.cfg
mkinitcpio -P
# ------------------------------------

# enable ssdm
systemctl enable sddm

# --------------------------- enable multilib pacman --------------------------
sed -ie "s/^#\s*\(\[multilib\]\)/\1/; /^\s*\(\[multilib\]\)/{n;s/#//}" /etc/pacman.conf
# ---------------------------------------------------------------------------


# yay install 

currentdir=`pwd`
cd /opt
sudo git clone https://aur.archlinux.org/yay.git
sudo chown -R sukai:sukai ./yay
cd yay
yes | makepkg -si
cd $currentdir
echo you finished second part installation, now reboot and move to next part 
echo remember to umount R parameter mnt folder please after exit and then reboot



















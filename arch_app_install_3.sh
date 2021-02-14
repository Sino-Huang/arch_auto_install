#!/bin/bash

# SIGINT is when you press ctrl+C, trap it and exit 
# trap single quote, only analyse the command when triggered
trap 'catch INT signal\n"; exit' SIGINT SIGTERM
# kill 0 will send SIGINT signal to all group process, but kill 0 is dangerous!
trap 'echo "catch EXIT signal\n"; kill $beatpid ' EXIT

# -----------------------------------  sudo beat ---------------------------------------
# get sudo and || means only if sudo -v fails, it will run the second command, $? means get the signal from the previous command
sudo -v || exit $?

# just wait for a while so that the credential is saved in cache 
sleep 1

# while loop
{
    # save child pid 
    echo "child process is $BASHPID"
    echo "$BASHPID" > "/tmp/tempsudobeat-$(date +%Y-%m-%d)-$$.txt"
    
    while true 
    do
        echo "sudo beat! BOOM!"
        # -n means if require password then directly exit, -v means extend sudo timeout
        sudo -n -v
        sleep 30
    done 

}&

# let sudo beat child process to warm up
echo Going is to install useful apps 
sleep 3

read beatpid < "/tmp/tempsudobeat-$(date +%Y-%m-%d)-$$.txt"
# --------------------------------------------- sudobeat ---------------------------------------------

# utils 
mkdir $HOME/tools
mkdir $HOME/Documents
mkdir $HOME/Downloads
mkdir $HOME/Pictures
mkdir $HOME/Videos
mkdir $HOME/Music
mkdir $HOME/Pictures/wallpapers

# update repositories 
sudo pacman -Sy --noconfirm
yes | yay -Sy --noconfirm
echo laptop 1 or desktop 2
read usersinput 
[[ "$usersinput" == "1" ]] && yay -S --noconfirm optimus-manager-qt 

sudo bash ./copy_package load
bash ./copy_documents load


# install fonts
sudo pacman -S --noconfirm --needed noto-fonts-cjk ttf-sarasa-gothic ttf-liberation wqy-zenhei

# install zsh 
yay -S --noconfirm oh-my-zsh-git

# install fcitx 
sudo pacman -S --noconfirm fcitx5-im fcitx5-qt fcitx5-gtk fcitx5-configtool fcitx5-chinese-addons fcitx5-rime
cat >$HOME/.pam_environment <<EOL
GTK_IM_MODULE   DEFAULT=fcitx
QT_IM_MODULE    DEFAULT=fcitx
XMODIFIERS      DEFAULT=\@im=fcitx
SDL_IM_MODULE   DEFAULT=fcitx
EOL


# settle wallpapers 
rsync -avP ./background.jpg         $HOME/Pictures/wallpapers
rsync -avP ./vim_wallpaper.jpg      $HOME/Pictures/wallpapers
rsync -avP ./cli_wallpaper.png      $HOME/Pictures/wallpapers
rsync -avP ./regex_wallpaper.png    $HOME/Pictures/wallpapers
# # now send to kde
# qdbus org.kde.plasmashell /PlasmaShell org.kde.PlasmaShell.evaluateScript '
#     var allDesktops = desktops();
#     var wallpaperlist = ["file:///home/sukai/Pictures/wallpapers/background.jpg",
#                          "file:///home/sukai/Pictures/wallpapers/vim_wallpaper.jpg",
#                          "file:///home/sukai/Pictures/wallpapers/cli_wallpaper.png",
#                          "file:///home/sukai/Pictures/wallpapers/regex_wallpaper.png"];
#     print (allDesktops);
#     for (i=0;i<allDesktops.length;i++) {
#         d = allDesktops[i];
#         d.wallpaperPlugin = "org.kde.image";
#         d.currentConfigGroup = Array("Wallpaper",
#                                      "org.kde.image",
#                                      "General");
#         if (i < 4) {
#             d.writeConfig("Image", wallpaperlist[i]);
#         }
#         
#     }
# '

# install other utils 
sudo pacman -S --noconfirm --needed cmake fmt

# git setup 
git config --global user.name "Sukai Huang"
git config --global user.email "u6492211@anu.edu.au"

# cat /dev/zero will always output null ssh setup
cat /dev/zero | ssh-keygen -t rsa -f $HOME/.ssh/id_rsa -q -P ""

# java installation 
sudo pacman -S --noconfirm jdk-openjdk

# tree showing files
sudo pacman -S --noconfirm tree

# nixnote2
yay -S --noconfirm nixnote2-git

# typora 
yay -S --noconfirm typora

# vlc
sudo pacman -S --noconfirm vlc

# thunderbird email
sudo pacman -S --noconfirm thunderbird

# krita
sudo pacman -S --noconfirm krita

# xournalpp
sudo pacman -S --noconfirm xournalpp

# better image viewer
sudo pacman -S --noconfirm geeqie

# imagemagick
sudo pacman -S --noconfirm --needed imagemagick
rsync -avPh convertjpg_to_pdf.sh $HOME/Documents/convertjpg_to_pdf.sh

# pcloud
rsync -avPh ./pcloud $HOME/tools/pcloud

# standard notes
yay -S --noconfirm standardnotes-bin

# shotcut
sudo pacman -S --noconfirm shotcut

# latex
sudo pacman -S --noconfirm texlive-latexextra texstudio

# steam
sudo pacman -S --noconfirm steam lib32-nvidia-utils 

# opencv
sudo pacman -S --noconfirm --needed opencv

# boost
sudo pacman -S --noconfirm --needed boost boost-libs

# anaconda and pytorch 
bash ./copy_anaconda.sh load
bash $(find ./ -iregex "./Anaconda.*\.sh" | head -n 1) -b -p $HOME/anaconda3

eval "$(~/anaconda3/bin/conda shell.bash hook)"

conda init

conda config --set auto_activate_base false

# install pytorch scrapy etc 
$HOME/anaconda3/bin/conda install scrapy pytorch torchvision torchaudio cudatoolkit=11.0 -c pytorch --yes
$HOME/anaconda3/bin/conda install selenium --yes

sudo rsync -avPh ./geckodriver /usr/bin

# install someother using pip
source $HOME/anaconda3/etc/profile.d/conda.sh && conda activate 
# pip does not have yes
pip install git+https://github.com/pytube/pytube 
pip install opencv-python
pip install opencv-contrib-python
pip install chompjs
pip install scrapy-splash

conda deactivate

# install vscode 
sudo pacman -S --noconfirm code


# install pycharm and intellij
yay -S --noconfirm pycharm-professional
yay -S --noconfirm intellij-idea-ultimate-edition

# install clion
yay -S --noconfirm clion

# install microsft team
yay -S --noconfirm teams

# zoom
yay -S --noconfirm zoom

# firefox 
sudo pacman -S --noconfirm --needed ffmpeg
sudo pacman -S --noconfirm firefox

# docker
sudo pacman -S --noconfirm docker
sudo usermod -aG docker $USER

# copy back nixnote and thunderbird data
bash ./copy_evernotes.sh load
bash ./copy_thunderbirds.sh load


shutdown +10




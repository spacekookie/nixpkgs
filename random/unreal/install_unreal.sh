#!/bin/bash

# This script installs the Unreal Engine 4 onto your system!
#
# Requirements:
#     - Have the following dependencies installed: cmake, clang 3.5, mono and dos2unix
#     - Have access to the Epic Games Github profile (You need to clone source)
#     - Several hours of your time. 
#         - 50MBit/s took an hour to download the entire engine repo
#         - On my 4GHz Phenom II X6 compiling took ~50 minutes.
#
# If you find any bugs with this script, please label it with '[INSTALL UNREAL]:'
# Written by Katharina 'spacekookie' Fey, April 2016
# 

echo "Welcome to the (mostly) automated UnrealEngine 4 installer script"

# Fix potential linker issues with clang
mkdir ~/bin/ && cd ~/bin/ && ln -s /bin/ld.bfd ./ld.gold
export PATH=$HOME/bin:$PATH

# Makre sure we're at home
cd ~

# Clone the source
git clone -b release https://github.com/EpicGames/UnrealEngine.git

# Configure compilation
cd UnrealEngine
bash Setup.sh
bash GenerateProjectFiles.sh

# Then compile (This will take a while...)
time make UE4Editor UE4Game UnrealPak CrashReportClient ShaderCompileWorker UnrealLightmass

echo "################# COMPILATION COMPLETE #################"

cd ~

# FIXME: Let's maybe include this in the script? :)
wget http://4.bp.blogspot.com/-Lo2MhQYl-fo/VnWrsXpxk8I/AAAAAAAAC08/hujgnz2KrTY/s1600/qLLBiqBE.png -O icon.png

sudo mv UnrealEngine/ /usr/local/share/
sudo mv icon.png /usr/local/share/UnrealEngine/
sudo ln -s /usr/local/share/UnrealEngine/Engine/Binaries/Linux/UE4Editor /usr/bin/ue4editor

cat > ~/ue4editor.desktop <<- EOM
[Desktop Entry]
Name=Unreal Engine 4
GenericName=Next-Gen Video Game Engine
Comment=Create stunning video games and cinematic scenes
Exec=/usr/bin/ue4editor
Icon=/usr/local/share/UnrealEngine/icon.png
Terminal=false
Type=Application
StartupNotify=false
Categories=Development;Games;
EOM

sudo mv ~/ue4editor.desktop /usr/share/applications/

echo "Installation complete. Enjoy your engine!"

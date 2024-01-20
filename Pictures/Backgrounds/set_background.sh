#!/usr/bin/env bash

backgrounds=$(ls $HOME/Pictures/Backgrounds/ --hide *.sh)
len=$(echo $backgrounds | awk "{print NF }")
index=$(($RANDOM % $len + 1))
bg=$(echo $backgrounds | awk "{print \$$index}")
echo $bg
path="file:///home/ciruela/Pictures/Backgrounds/$bg"
gsettings set org.gnome.desktop.background picture-uri-dark $path

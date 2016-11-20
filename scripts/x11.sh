#!/bin/sh

echo x11
yum -y groupinstall "X Window System"
yum -y groupinstall "Desktop"
yum -y groupinstall "Fonts"
yum -y install firefox
startx

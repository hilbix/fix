#!/bin/bash
#
# Disable Ubunut Desktop Background and set it entirely black
#
# I really have no idea why this setting vanished!
# See https://askubuntu.com/a/1385645/164798

gsettings set org.gnome.desktop.background picture-options 'none'
gsettings set org.gnome.desktop.background primary-color '#000000'
gsettings set org.gnome.desktop.background secondary-color '#000000'


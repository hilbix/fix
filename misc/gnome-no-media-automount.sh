#!/bin/bash
#
# Automounting may destroy media

gsettings set org.gnome.desktop.media-handling automount      false
gsettings set org.gnome.desktop.media-handling automount-open false

echo "WARNING!  Following crashes X11"
read -p 'press RETURN: ' && sudo systemctl restart gdm.service


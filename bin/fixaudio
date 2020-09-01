#!/bin/bash
#
# After switching/restarting X11 youtube stays mute in browser?
# When you are using pulseaudio just run this.
# Close the TAB and reopen - now sound should play again.
# (Perhaps you need to fix the audio system settings, too.)
#
# Note:
#
# Before Ubuntu 18.04.1 this also enabled beeping in terminal.
# But something changed which I do not know, hence beep stays mute.

mv -Tf --backup=t "$HOME/.config/pulse" "$HOME/.config/pulse.old"

pulseaudio --check
pulseaudio -k

sleep 1

for a in {1..10}
do
	sudo killall -9 pulseaudio
	sleep .1
done
sleep 2

pulseaudio -D
sleep 1

# apt-get install ubuntu-sounds
pactl upload-sample /usr/share/sounds/ubuntu/stereo/bell.ogg bell.ogg

# /etc/pulse/default.pa:
# load-sample-lazy x11-bell /usr/share/sounds/ubuntu/stereo/bell.ogg
# load-module module-x11-bell sample=bell-windowing-system


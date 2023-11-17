#!/bin/bash
#
# After switching/restarting X11 youtube stays mute in browser?
# Or after screen blanking your audio starts to sound crazy?
#
# When you are using pulseaudio run this.
# Close the TAB and reopen - now everything should play again.
# (Perhaps you need to fix the audio system settings, too.)
#
# Note:
#
# Before Ubuntu 18.04.1 this also enabled beeping in terminal.
# But something changed which I do not know, hence beep stays mute.

mv -Tf --backup=t "$HOME/.config/pulse" "$HOME/.config/pulse.old"

# Everything around Pulseaudio loves to hang or crash at my side various mystic ways.  YMMV
sink="$(timeout 10 pactl get-default-sink)" && [ -n "$sink" ] && echo "${sink%.*} ${sink##*.}" >"$HOME/.config/fixaudio.pulseaudio.sink"
timeout 10 pulseaudio --check
timeout 10 pulseaudio -k

sleep 1

# Pulseaudio usually does not react on above control commands at my side
for a in {1..10}
do
	sudo killall -9 pulseaudio
	sleep .1
done
sleep 2

# Run a fresh version again as Daemon
# (usually it works until I the screens change, most often due to blanking)
pulseaudio -D
sleep 1

# apt-get install ubuntu-sounds
#pactl upload-sample /usr/share/sounds/ubuntu/stereo/bell.ogg bell.ogg ||
#echo "sudo apt install ubuntu-sounds # this is probably missing"

# /etc/pulse/default.pa:
# load-sample-lazy x11-bell /usr/share/sounds/ubuntu/stereo/bell.ogg
# load-module module-x11-bell sample=bell-windowing-system

# Try to re-establish the previous SINK
# (because the one Pulseaudio selects by default is usuallt the wrong one)
# This assumes that Pulseaudio profiles do not contain a . (as cards can)
# And do not ask me why it works if it works
read CARD PROFILE < "$HOME/.config/fixaudio.pulseaudio.sink" &&
pacmd set-card-profile "alsa_card.${CARD#*.}" "output:$PROFILE" &&
pacmd set-default-sink "$CARD.$PROFILE"
# Perhaps we should do this with the input, too?


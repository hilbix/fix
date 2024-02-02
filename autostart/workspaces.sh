#!/bin/bash
#
# Gnome/Wayland collapses unused workspaces which is very annoying for me.
# This here keeps the given number of workspaces open
# by adding some xeyes on the lower left corner.
#
# Rename to the number of desktops/workspaces like:
#	workspaces22.sh
# which would creates 0..22 aka 23 workspaces
#
# Tested on Ubuntu 22.04 with Gnome on Wayland on multi screens
# Note that xeyes no more work correctly in that setup.
# But this is some entirely different story.

x="${0##*/}"
x="${x%.*}"
x="${x##*[^0-9]}"
x="${x:-9}"		# 9 gives 10 workspaces by default, override with name
eval "all=({0..$x})"

export DISPLAY=:0
printf '\n%(%Y%m%d-%H%M%S)T %s\n' -1 start
t=1
while	! read -t$t a || [ x == "$a" ]
do
	t=300		# refresh all 5 minutes or so in case some xeyes gets killed
	printf . || break
	for a in "${all[@]}"
	do
		while	! wmctrl -F -r XEYES-DESK$a -t $a
		do
			t=1
			printf %q "$a" || break 3
			# xprop no more works after rename
			xprop -name xeyes -format _MOTIF_WM_HINTS 32i -set _MOTIF_WM_HINTS 2 2>/dev/null &&
			# rename the window, so we know where it belongs
			wmctrl -F -r xeyes -T XEYES-DESK$a && continue
			# above fails, spawn a new xeyes in the background
			printf %q + || break 3
			# +0-0 is the lower left corner
			# -0-0 is the lower right corner but needs multi-screens aligned at the bottom
			(setsid xeyes -geometry +0-0 & ) >/dev/null 2>/dev/null
			break 2
		done
	done
done

printf '\n%(%Y%m%d-%H%M%S)T %s\n' -1 end


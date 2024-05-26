#!/bin/bash
#
# Gnome/Wayland collapses unused workspaces which is very annoying for me.
# This here keeps the given number of workspaces open
# by adding some xeyes on the lower left corner.
#
# Rename to the number of desktops/workspaces like:
#	workspaces22.sh
# which creates 0..22 aka 23 workspaces
#
# Tested on Ubuntu 22.04 with Gnome on Wayland on multi screens
# Note that xeyes no more work correctly in that setup.
# But this is some entirely different story.

# +0-0 is the lower left corner
# -0-0 is the lower right corner but needs multi-screens aligned at the bottom
POS=+0-0

x="${0##*/}"
x="${x%.*}"
x="${x##*[^0-9]}"
x="${x:-9}"		# gives 10 workspaces by default, override with name
eval "all=({0..$x})"

printf '\n%(%Y%m%d-%H%M%S)T %s\n' -1 start || exit
t=1
while	! read -t$t a || [ x == "$a" ]
do
	t=300		# refresh all 5 minutes or so in case some xeyes gets killed

	# locate the current X11 display
	xset q >/dev/null ||
	{
	t=15		# retry desktop to appear in 15s
	[ -z "$DISPLAY" ] || printf '\n%(%Y%m%d-%H%M%S)T DISPLAY %q vanished\n' -1 "$DISPLAY" || exit
	DISPLAY=
	for a in /tmp/.X11-unix/X*
	do
		[ -w "$a" ] || continue
		export DISPLAY=":${a#*/X}"
		xset q >/dev/null || continue
		printf '%(%Y%m%d-%H%M%S)T DISPLAY=%q\n' -1 "$DISPLAY" || exit
		t=.1	# found display
		break
	done
	continue
	}

	# Check that our precious xeyes are still there
	MISS=()
	for a in "${all[@]}"
	do
		wmctrl -F -r XEYES-DESK$a -t $a || MISS+=($a)
	done

	printf %d "${#MISS[@]}" || exit

	[ -z "$MISS" ] && continue		# nothing to do

	# fork the missing xeyes independently from us
	PIDS=()
	for a in "${MISS[@]}"
	do
		PIDS+=("$( setsid xeyes -geometry $POS >/dev/null 2>/dev/null & echo $a $! )")
	done

	# Wish there would be a reliable way to:
	# - register a list of PIDs to get notified if they die
	# - get the PID of a running X11 window
	# without using some highly stupid polling
	for a in "${PIDS[@]}"
	do
		# check PID still there (assumes it is not replaced too fast)
		while	sleep .2
			kill -0 "${a##* }"
		do
			# remove decoration
			# loops if window is not yet ready
			xprop -name xeyes -format _MOTIF_WM_HINTS 32i -set _MOTIF_WM_HINTS 2 2>/dev/null || continue
			# xprop no more works after rename
			# rename the window, so we know where it belongs
			wmctrl -F -r xeyes -T XEYES-DESK${a%% *} || break 2

			# these eyes are done, proceed to next
			break
		done
	done

	t=.1	# loop fast
done

printf '\n%(%Y%m%d-%H%M%S)T %s\n' -1 end


#!/bin/bash
#
# I really do not know why some PCI hardware needs this.
#
# Check some hardware PCI network interface to be able to reach something.
# If not, reset the interface.
#
# Define the list of hosts to probe in /etc/hosts via lines like this:
# 1.2.3.4	$DEV.checks.
#
# This tries to be clever in very simple cases without configuration.
# However for complex setups like multiple links, this will fail.

DEF=eno1
ASS[eno1]=lan0

PATH="/usr/sbin:$PATH"

# Try DEVs from arguments
# or filename (namewithoutdash-DEVICE.*)
# or devices in /sys/class/net
# or default given above

DEV="${0%%.*}"
for DEV in "$@" "${0#"${DEV%%-*}"}" `ls -1 /sys/class/net` $DEF
do
	[ -d "/sys/class/net/$DEV/device" ] && break
done

BUS="$(readlink -e /sys/class/net/$DEV/device)" || BUS="$(readlink -e "/sys/bus/pci/devices/0000:$(lspci | awk '/Ethernet/ { print $1; exit }')")"

IPS="$(getent hosts "$DEV.checks." | awk '{ print $1 }' | tr \\n ' ')"
[ -n "$IPS" ] || IPS="$(ip -o r g 1 | awk '/ via / { sub(/^.* via /,""); gsub(/ .*$/,""); print }')"

[ -d "$BUS/net/$DEV" ] || printf '\n!WARNING! %q not found\n' "$DEV"
echo on > "$BUS/power/control" || printf "\n!WARNING! %q not found\n" "$BUS"

while	printf '%(%Y%m%d-%H%M%S)T %q %s ' -1 "$DEV" "$IPS"
do
	while	read -t20 && exit 2
		fping -qx1 $IPS >/dev/null
	do
		printf . || exit
	done

	printf '\n%(%Y%m%d-%H%M%S)T '
#	printf ' %q' $IPS; printf '\n'

#	set -x
	#/sys/class/net/$DEV/power/control
	echo 1 > "$BUS/remove"
	sleep 1
	echo 1 > /sys/bus/pci/rescan
	sleep 1
	echo on > "$BUS/power/control"
	sleep 1
	ifup $DEV
	sleep 1
	ethtool -r $DEV
	sleep 1
	ethtool $DEV
	set +x

	for a in ${ASS["$DEV"]}
	do
		ifdown "$a"
		sleep 1
		ifup "$a"
	done
done


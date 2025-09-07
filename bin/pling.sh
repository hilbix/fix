#!/bin/bash

pinger()
{
fping -qr3 "$1"
}

if [ 1 != $# ]
then
	echo "oops, one arg: IP"
	exit 1
fi

state=undefined
while :
do
	read -t1 ent &&
	case "$ent" in
	exit)	exit 0;;
	*)	last="$ret"
		echo "`date +%Y%m%d-%H%M%S` confirm $state"
		;;
	esac

	pinger "$1"
	ret="$?"
	case "$ret" in
	0)	echo -n .;;
	1)	echo -n x;;
	*)	echo -n \?;;
	esac
	if [ ".$was" != ".$ret" ]
	then
		state="unknown: $ret"
		case "$ret" in
		0)	state=alive;;
		1)	state=down;;
		esac
		echo "`date +%Y%m%d-%H%M%S` $state $1"
		was="$ret"
	fi
	[ ".$last" = ".$ret" ] && continue
	echo -ne '\a'
done

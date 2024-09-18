#!/bin/bash
#
# pvmover.sh SRC DEST extend[-extend[/size]] extend[-extend[/size]]..
#
# After 40 hours at 99% I used pvmove --abort
# and all the 99% were gone, nothing moved.
#
# The extends are from the source drive.  /size defaults to 1000
#
# WTF?!?!
#
# So I decided to do this here.  This moves max packages of 1000 extends until something fails ..

STDOUT() { printf %q "$1"; [ 1 -ge "$#" ] || printf ' %q' "${@:2}"; printf '\n'; }
STDERR() { local e=$?; STDOUT "$@" >&2; return $e; }
OOPS() { STDERR OOPS: "$@"; exit 23; }
x() { STDERR exec: "$@"; "$@"; STDERR ret$?: "$@"; }
o() { x "$@" || OOPS fail $?: "$@"; }

FROM="$1"
TO="$2"

shift 1

while	shift 1 && [ -n "$1" ]
do
	s="${1#*/}"
	[ ".$s" != ".$1" ] || s=1000
	b="${1%%/*}"
	a="${b%%-*}"
	b="${b##*-}"
	case "$a$b$s" in
	(*[^0-9]*)		OOPS not number: "$a" "$b" "$c";;
	esac

	while	[ "$a" -le "$b" ]
	do
		let c=a+s-1
		[ "$b" -ge "$c" ] || c="$b"

		printf '%(%Y%m%d-%H%M%S)T %q-%q\n' -1 "$a" "$c" && ! read -t0.1 || exit

		o pvmove "$FROM:$a-$c" "$TO"
		let a=c+1
	done
done


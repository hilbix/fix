#!/bin/bash
# see /etc/suid.conf.d/apt-up.conf

stamp() { printf '%(%Y%m%d-%H%M%S)T %d: ' -1 "$?" || exit; [ 0 = $# ] && return; printf '%q ' "$@" && printf '\n'; }
x() { stamp "$@" && "$@"; }

export LC_ALL=C.UTF-8 || export LC_ALL=C;
export LINES=40 COLUMNS=132;
export TERM=xterm-256color || export TERM=xterm || export TERM=linux || export TERM=vt100;

while	stamp && read -r cmd && stamp "$cmd";
do
	case "$cmd" in
	('')	x /root/.apt && x /usr/bin/apt dist-upgrade && x /root/.apt;;
	esac;
	stamp 'done';

	while read -rt0.1 x; do :; done;
done;

stamp EOF


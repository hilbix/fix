#!/bin/bash
# see /etc/suid.conf.d/apt-up.conf

stamp() { printf '\n%(%Y%m%d-%H%M%S)T %d %q: ' -1 "$?" "$TERM" || exit; [ 0 = $# ] && return; printf '%q ' "$@" && printf '\n\n'; }
x() { stamp "$@" && "$@"; }

export LC_ALL=C.UTF-8 || export LC_ALL=C;
export LINES=40 COLUMNS=132;
export TERM=xterm-256color && tput init || export TERM=xterm && tput init || export TERM=linux && tput init || export TERM=vt100 && tput init || export TERM=dumb;
export DEBIAN_FRONTEND=readline;
X='#';

while	stamp && read -ra cmd && stamp "$cmd";
do
	case "${#cmd[@]} ${cmd[0]}" in
	('1 help')	sed -n "s/^\\t([^ ]* \\([^']*\\)')[^$X]*/\\1\t/p" "$0";;		# show help
	('1 dist')	x /root/.apt && x /usr/bin/apt dist-upgrade && x /root/.apt;;		# dist update
	([2-9]' echo')	printf -vT '%(%s)T' -2 && stamp PONG "$T" "${cmd[@]:1}";;		# echo XXX
	('1 os')	cat /etc/os-release;;							# print os-release
	('1 reexec')	exec "$0";;								# reexec script
	('1 restart')	/usr/sbin/needrestart -v -ma;;						# run needrestart
	('1 safe')	x /root/.apt && x /usr/bin/aptitude safe-upgrade && x /root/.apt;;	# aptitude safe-upgrade
	('1 up')	x /root/.apt && x /root/.apt;;						# normal update
	(*)		stamp try help: unknown command: "$cmd"; false; continue;;
	esac;
	stamp 'done';

	while read -rt0.1 x; do :; done;
done;

stamp EOF;


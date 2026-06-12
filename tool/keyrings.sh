#!/bin/bash
#
# To install packages which do not put anything into /etc/apt/ use:
#	misc/keyrings.sh all
# To install packages even which put things into /etc/apt/ use:
#	misc/keyrings.sh apt
# To install a certain package, use:
#	misc/keyrings.sh package
# To install really all packages with keyrings, use:
#	misc/keyrings.sh '*'

OK=()
ALL=()
WARN=()
HUH=()
INS=()
while read -ru6 p
do
	files=0
	WTF=
	KEYS=0
	DOC=0
	APT=0
	ETC=0
	BIN=0
	while read -ru6 a b
	do
		let files++
		[ ".$a" = ".$p:" ] || WTF="$a"
		case "$b" in
		(/usr/share/*.gpg)	let KEYS++;;
		(/usr/share/*)		let DOC++;;
		(/usr/doc/*)		let DOC++;;
		(/etc/apt/*)		let APT++;;
		(/etc/)			let ETC++;;
		(*/bin/*)		let BIN++;;
		(*/lib*)		let BIN++;;
		esac
	done 6< <(apt-file list "$p")

	case "$APT:$BIN:${WTF:+x}" in
	(0:0:)	f=0; OK+=("$p");;
	(0:*:)	f=1; ALL+=("$p");;
	(*:*:)	f=2; WARN+=("$p");;
	(*)	f=3; HUH+=("$p");;
	esac;

	for b;
	do
		case "$f:$p" in
		(?:$b)		;;
		([01]:*)	[ all = "$b" ] || continue;;
		(2:*)		[ apt = "$b" ] || continue;;
		(*)		continue;;
		esac;
		INS+=($p);
		break;
	done;
	printf '%-30s key:%3d doc:%4d etc:%3d apt:%3d bin:%3d %s\n' "$p" "$KEYS" "$DOC" "$ETC" "$APT" "$BIN" "$WTF"
done 6< <(apt-file search keyring | grep -- '\.gpg$' | sed -n 's/: .*$//p' | uniq)

[ 0 = $# ] && INS=("${OK[@]}");

( set +x; apt install "${INS[@]}" );

# TODO: Add some overview here


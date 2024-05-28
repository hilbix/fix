#!/bin/bash
#
# Move windows to other workspaces
#
# wmmove.sh		lists count of movable windows on all workspaces (not all work, sadly)
# wmmove.sh DESK	lists movable windows on workspace DESK
# wmmove.sh FROM TO	moves all movable windows on workspace FROM to workspace TO
# wmmove.sh FROM TO SEL	moves all movable windows on workspace FROM with SEL in title to workspace TO

STDOUT() { printf %q "$1"; [ 1 -ge $# ] || printf ' %q' "${@:2}"; printf \\n; }
STDERR() { STDOUT "$@" >&2; }
OOPS() { STDERR OOPS: "$@"; exit 23; }

all()
{
  local x="`cat`"
  wmctrl -l | gawk "$@" '$4 ~ /^XEYES-DESK/ { next } '"$x"
}

lists()
{
  all <<'EOF'
	{ x=0+$2; cnt[x]++; if (max<x) max = x; have[x]=have[x] " " $4 }
END	{ for (i=0; i<=max; i++) if (cnt[i]) print i "\t" cnt[i] have[i] }
EOF
}

list()
{
  all -vWIN="$1" <<<'$2 == WIN { print }'
}

move()
{
  while read -ru6 id x x rest
  do
	case "$rest" in
	(*"$3"*)	wmctrl -i -r "$id" -t "$2";;
	(*)		echo "ignored: $id $rest";;
	esac
  done 6< <(list "$1")
}

case $# in
(0)	lists;;
(1)	list "$1";;
(2)	move "$1" "$2";;
(3)	move "$1" "$2" "$3";;
(*)	OOPS WTF: "$@";;
esac


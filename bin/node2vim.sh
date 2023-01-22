#!/bin/bash
#
# in Makefile:
#	node2vim.sh nodejs script.js args
#
# ~/.vimrc needs:
#	set efm+=#%t#%f#%l#%c#%m#
#	set efm+=#%t#%f#%l##%m#
#	set efm+=#%t#%f###%m#
#	set efm+=#%t#%f##%c#%m#

exec "$@" 2> >(
gawk -v ARG="$(readlink -e -- "$2")" '
match($0,"^    at ([^(]+) \\(([^)]*):([0-9]+):([0-9]+)\\)",a)	{
	if (a[2] ~ /^internal\/modules\//)
	  print "#E#" ARG "#1#0#{" a[1] "} " last "#";
	else
	  print "#E#" a[2] "#" a[3] "#" a[4] "#{" a[1] "} " last "#";
	next;
	}
# dequote # and : which might irritate vim
{ sub(/^#/,"-- #"); last=gensub(/:([^ ])/, ": \\1", "g"); print last }
' >&2)


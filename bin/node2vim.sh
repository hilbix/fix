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
gawk -v ARG="$2" '
#{ print match($0,"^    at [a-zA-Z0-9_.<>]+ \\(([^)]*):([0-9]+):([0-9]+)\\)",a) }
match($0,"^    at [a-zA-Z0-9_.<>]+ \\(([^)]*):([0-9]+):([0-9]+)\\)",a)	{
	if (a[1] ~ /^internal\/modules\//)
	  print "#E#" ARG "#1#0#" last "#";
	else
	  print "#E#" a[1] "#" a[2] "#" a[3] "#" last "#";
	next;
	}
# dequote # and : which might irritate vim
{ sub(/^#/,"-- #"); gsub(/:[^ ]/, ": "); last=$0; print }
' >&2)


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
#
# Sigh, re-inventing the wheel ..

# find the first existing argument
for a in "${@:2}"
do
	case "$a" in
	(-*)	continue;;
	esac
	ARG="$(readlink -e -- "$a")" && break
done

exec "$@" 2> >(
gawk -v ARG="$ARG" -F: '
function show(a,b,c,d)
{
  if (a ~ /^internal\/modules\//)
    print "#E#" ARG "#1#0#" d "#";
  else
    print "#E#" a "#" b "#" c "#" d "#";
}
#BEGIN	{ print "ARG " ARG }
$1==ARG && $2 ~ /^[0-9]+/					{ first=$0; linenr=$2; trig=1; next }
trig==1								{ line=$0; trig=2; next }
trig==2 && match($0,"^( *)\\^$",a)				{ show(ARG, linenr, length(a[1]), line); trig=0; next }
trig								{ print first; print line; trig=0 }
match($0,"^    at ([^(]+) \\(([^)]*):([0-9]+):([0-9]+)\\)",a)	{ show(a[2], a[3], a[4], "{" a[1] "} " last); next }
match($0,"^    at ([^()]*):([0-9]+):([0-9]+)",a)		{ show(a[1], a[2], a[3], last); next }
# dequote # and : which might irritate vim
{ sub(/^#/,"-- #"); last=gensub(/:([^ ])/, ": \\1", "g"); print last }
' >&2)


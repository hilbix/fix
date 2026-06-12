#!/bin/bash
#
# vim: ft=bash

cd "$(dirname -- "$0")" || exit;

rm -vf ../*/*.log;

printf -v NOW '%(%Y%m%d-%H%M%S)T';

for a in ../*/*.out;
do
	[ -s "$a" ] || continue;
	for b in "$a".*.old;
	do
		[ -s "$b" ] && bzip3 -v --rm --batch "$b";
	done;
	mvatom -v "$a" "$a.$NOW.old";
done;


#!/bin/bash
#
# vim: ft=bash
#
# bz does pack slightly better (3%) than gz and runs a bit slower
# xz does pack better (15%) but is far too slow

uname -a;

cd /boot || exit;

select a in vmlinuz-*;
do
	b="${a#vmlinuz-}";
	t="${1:-.}/$b";
	tar cvfz "$t.tmp" -- "/lib/modules/$b/" /boot/grub/ /boot/efi/ /boot/.x /boot/*-"$b"* &&
	sync "$t.tmp" &&
	tar Cdfz / "$t.tmp" &&
	mv -v --backup=t "$t.tmp" "$t.tgz";
done


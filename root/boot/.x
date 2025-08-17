#!/bin/bash
#
# bz does pack slightly better (3%) than gz and runs a bit slower
# xz does pack better (15%) but is far too slow

uname -a

select a in vmlinuz-*
do
	b="${a#vmlinuz-}"
	tar cvfz "$b.tmp" -- "/lib/modules/$b/" grub efi .x *-"$b"*
	sync "$b.tmp"
	mv -v --backup=t "$b.tmp" "$b.tgz"
done


#!/bin/bash

show()
{
echo "$*:"
tput sgr0
while read -ru6 line
do
	case "$line" in
	('b5eeb4a670 Microsoft UEFI CA 2023') 			tput setaf 2;;
	('46def63b5c Microsoft Corporation UEFI CA 2011')	tput setaf 1;;
	esac
	echo "$line"
	tput sgr0
done 6< <(mokutil --db --short)
echo
}

show Before
chattr -i /sys/firmware/efi/efivars/db-* &&
efi-updatevar -a -f DBUpdate3P2023.bin db &&
chattr +i /sys/firmware/efi/efivars/db-*
show After

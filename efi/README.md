# EFI helpers

I do not grok EFI updates.  Sorry.

Hence here are some helpers I tried to write to not always bend my poor old brain into unusual contorsions.

Use with care.  If it breaks, you broke it such that I cannot and will not help you.

Here are some snippets I recorded while my brain tried to escape my skull.
Use it for your benefit or ignore it, as I really have no idea anymore why I bothered to write it down:

	apt-file search DBUpdate3P2023

	apt install nvme-cli fwupd mokutil udisks2 efitools gcap
	nvme smart-log /dev/nvme0

	parted /dev/nvme0n1 set 1 esp on

	fwupdmgr refresh
	fwupdmgr get-updates
	fwupdmgr upgrade

	/usr/bin/fwupdtool esp-list --verbose

	mokutil --db --short


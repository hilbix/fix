#

# Why full -> nosrc and not opposit?
# Because there might be sources without sources
love:	keyrings/microsoft.gpg keyrings/cuda-archive-keyring.gpg
	for a in sources.list.d/full/*; do	\
		sed 's/^\tdeb-src\t/#\tdeb-src\t/' "$$a" > "sources.list.d/nosrc/`basename -- "$$a"`";	\
		x="`awk '$$3 ~ /-backports$$/ { print $$3; exit; }' "$$a"`";	\
		[ -z "$$x" ] || { echo 'Package: *'; echo "Pin: release n=$$x"; echo 'Pin-Priority: 909'; }  > "preferences.d/99$$x";	\
	done

# see also tool/keyrings.sh

# apt install distribution-gpg-keys
keyrings/microsoft.gpg:	 /usr/share/distribution-gpg-keys/microsoft/microsoft.asc
	gpg --dearmor -o '$@' '$<'

# apt install extrepo-offline-data
keyrings/cuda-archive-keyring.gpg:	 /usr/share/extrepo/offline-data/debian/trixie/nvidia-cuda.asc
	gpg --dearmor -o '$@' '$<'


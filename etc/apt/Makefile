#
# Why full -> nosrc and not opposit?
# Because there might be sources without sources

love:
	for a in sources.list.d/full/*; do	\
		sed 's/^\tdeb-src\t/#\tdeb-src\t/' "$$a" > "sources.list.d/nosrc/`basename -- "$$a"`";	\
		x="`awk '$$3 ~ /-backports$$/ { print $$3; exit; }' "$$a"`";	\
		[ -z "$$x" ] || { echo 'Package: *'; echo "Pin: release n=$$x"; echo 'Pin-Priority: 909'; }  > "preferences.d/99$$x";	\
	done


#
# Why full -> nosrc and not opposit?
# Because there might be sources without sources

love:
	for a in full/*; do sed 's/^\tdeb-src\t/#\tdeb-src\t/' "$$a" > "nosrc/`basename -- "$$a"`"; done


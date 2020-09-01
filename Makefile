#

.PHONY:	love
love:	all

.PHONY:	all
all:
	[ -d "$$HOME/bin" ] || mkdir -vm 755 "$$HOME/bin"
	for a in bin/*; do cmp -s "$$a" "$$HOME/$$a" || ln --backup=t --relative -vs "$$a" "$$HOME/bin/."; done


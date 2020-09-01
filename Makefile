#

.PHONY:	love
love:	all

.PHONY:	all
all:	install

.PHONY:	install
install:
	[ -d "$$HOME/bin" ] || mkdir -vm 755 "$$HOME/bin"
	for a in bin/*; do cmp -s "$$a" "$$HOME/$$a" || ln --backup=t --relative -vs "$$a" "$$HOME/bin/."; done
	MORE=; [ 0 = "`id -u`" ] && MORE=root; for a in home $$MORE; do ( cd "$$a" && for b in *; do cmp -s "$$b" "$$HOME/.$$b" || ln --backup=t --relative -Tvs "$$b" "$$HOME/.$$b"; done ); done


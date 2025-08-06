#

.PHONY:	love
love:	all

.PHONY:	all
all:	install

.PHONY:	install
install:
	[ -d "$$HOME/bin" ] || mkdir -vm 755 "$$HOME/bin"
	for a in bin/*; do test ! -s "$$a" || cmp -s "$$a" "$$HOME/$$a" || ln --backup=t --relative -vs "$$a" "$$HOME/bin/." || exit $$?; done
	for a in home; do ( cd "$$a" && for b in *; do test ! -s "$$b" || cmp -s "$$b" "$$HOME/.$$b" || ln --backup=t --relative -Tvs "$$b" "$$HOME/.$$b"|| exit $$?; done ) || exit $$?; done
	#@[ 0 != "`id -u`" ] || { find root ! -uid 0 -print0 -o ! -gid 0 -print0 | xargs -r --null chown -vh 0:0 -- && find root ! -type l -perm /2 -print0 | xargs -r --null chmod -v o-w --; }
	# Beware of `sudo` linking to files not owned by `root` or which are world writeable
	[ 0 != "`id -u`" ] || { x="`find root \( ! -uid 0 -o ! -gid 0 -o ! -type l -perm /2 \) -ls -quit`" && [ -z "$$x" ] || { echo && echo "FAIL: not owned by root:root or world writable: $$x"; echo; exit 1; }; }
	[ 0 != "`id -u`" ] || { cd root && for a in *; do [ ! -d "$$a" ] && continue; find "$$a" ! -type d -print | while read -r b; do test ! -s "$$b" || cmp -s "$$b" "/$$b" || { mkdir -vp "/`dirname "$$b"`" && ln --backup=t --relative -Tvs "$$b" "/$$b"; } || exit $$?; done || exit $$?; done; }

.PHONY:	root
root:
	[ 0 = "`id -u`" ] || { echo && echo "FAIL: you are not root" && echo && exit 1; }
	$(MAKE) install
	systemctl restart systemd-journald systemd-logind
	systemctl daemon-reload


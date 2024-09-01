# Fixes

Various fixes and defaults

- See also [my howto-rants](https://github.com/hilbix/tino/tree/master/howto)

This here now bundles all my helpers without checking out all the babble.


## Warning!

As `root` this changes services to something which I think are reasonable:

- Reconfigured SystemD services are not restarted, for this do a `make root`
  - [Display the journal to `tty12`](https://bbs.archlinux.org/viewtopic.php?pid=1537385#p1537385)


## Usage

	cd
	cd git
	git clone https://github.com/hilbix/fix.git
	cd fix
	make



## Short description

`make` links (overwrites, with backup) following files in your `$HOME` with my defaults:

- `.tmux.conf` with `Ctrl+\` for switching panes
  - Two times to switch back and forth
  - `Ctrl+\` and `\` to send `Ctrl+\`
  - WARNING!  If you get trained to this (like me), you might send SIGQUIT to various shell processes if you are not in `tmux`
  - Have a look into the file to see all sequences
- `.vimrc` which enables various things
  - look into it, it is commented accordingly
- `.apt` if you are `root`
  - `./.apt` (in directory `/root`) is my way to upgrade my systems
  - It automatically disables PDiffs.  Even those the maintainers try to enforce against your will.
  - It does a (re)build of DKMS for all installed kernels
  - It also removes all no more needed previous versions of SNAPs to free up precious space in `/var`
  - It does not update SNAPs, though, because SNAPs cannot be cached.  I have to manually tear down firewalls first to update SNAPs.
  - To see which firewall rules are needed for SNAPs, have a look at the ever changing https://snapcraft.io/docs/network-requirements
  - Also note that firewall holes need a static set of IPs of course.  Dynamic things like domains are forbidden in secure contexts.

Put `$HOME/bin` into your path (usually this is already the case) to get this commands:

- `fixaudio.sh` kills and reloads pulseaudio.
  - When the audio starts to sound crappy at my side (which usually happens after switching on monitors) this fixes the problem.
  - It also tries to restore the previous output device profile, however this is very experimental
- `side-by-side FILEs..` puts the files side by side and automatically adopts to the maximum file length in each file
  - Example: `side-by-side <(df -h) <(df -hi)`
  - `stdin` is read if no file is given or `-` is present
  - `-vSEP=" seprarator "` selects another separator
  - You can give other `awk` options as well (as this is just some `awk` script)

Following `*vim.sh` scripts work together with my `.vimrc`, such that you can put the debug call into `Makefile` as the default rule.
If you then press `M` in `vim` this runs everything and automatically jumps to the first issue.

- `bash2vim.sh ./script args..` to debug `bash` scripts with `vim`
- `node2vim.sh nodejs script.js args..` to debug `node` type JavaScript with `vim`
- `python3vim.sh ./python-script.py args..` to debug `Python3` scripts
  - `watch python3vim.sh` to see the full debug output of the last invocation

`autostart/` contains some of my autostart scripts.

- Read the introductory comment on the scripts for what they are.
- They are installed or activated manually with something like  
  `ln -s --relative autostart/SCRIPT.sh ~/autostart/`
- This assumes you do autostarts like I do, see:  
   <https://github.com/hilbix/ptybuffer/blob/master/script/autostart.sh>


## FAQ

WTF why?

- Because checkouts of <https://github.com/hilbix/tino/tree/master/howto> start to become too big

License?

- All files are free as in free beer, free speech and free baby.
- Ever saw a Copyright on a baby?


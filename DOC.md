# Quick notes

## `others/`

Contains fixes found from others. grabbed from other sources.  To use them:

```
git submodule update --init --recursive
```

> Submodules are blessed in the sense, that they are safe against supply chain attacks as long as I am careful enough.


## `root/`

Contains some files which are only installed if you are `root`.


### `root/.apt`, `root/autostart/apt-up.sh`, `etc/suid.conf.d/apt-up.conf`

With `/root/.apt` I update my systems.

- `/root/autostart/apt-up.sh` is a proxy to run this on-demand in background.
  - Needs my tool `ptybuffer` and its helper cron script `autostart.sh` 
- `suid apt-up` is the way to access this proxy from unprivileged users
  - Needs my tool `suid`

### `boot/.x`

My way to create a backup of `/boot/`

- `/boot/.x` stores the `.tgz`s (named after the kernel) into `/boot`
- `/boot/.x /path` stores the `.tgz`s into `/path/`
- It replaces the old files (with `~`-Backups of the previous data)
- It does not (yet) work on Raspberry PI or similar `uboot` environments

> Note that `.x` stands for `exec` and means for me: "Just do what is to be done in this directory."


### `misc/`

- `disable-packagekit.sh` masks `packagekit.service`.  This is not needed and occupies small machines in unbearable ways.
- `gnome-no-media-automount.sh` disables automounting of media in `gnome` setups.
  - Else `gnome` triggers "self destruct" on certain USB devices when it tries to access them.
  - Note that this is exactly what these type of devices shall do:  Destroy itself if somebody tries to access them the wrong way.
- `ubuntu-nopic-black.sh` create a clean black desktop to safe power on OLED screens as it ought to be
  - Max. energy saving should always be the default, right?


### `etc/`

#### `systemd/`

- `tty12.conf` enables 11 login ttys and logging of syslog to `tty12`


#### `suid.conf.d/`

`suid` is a central piece to secure all my setups to get privileged access from unprivileged accounts.  It is designed:

- security first
- backward compatibility last
- just do only one thing and do it right
- (In future it might even support natively capabilities and namespaces.
  This already can be reached with proper toolings, but these are error prone to use and often a bit clumsy.)

> Hence `suid` is not such a moloch like `sudo` and does not rely on overly complex things like PAM or password and hence hopefully avoids all flaws of `sudo`.
>
> `suid` can be statically compiled to be used in `chroot`s in a standalone manner, too.


##### `sshd.conf`

`suid sshd` invokes `sshd -i` (inet mode from stdin) from unprivileged users.

- I always assume that `sshd` has a secured setup if available!
- This allows me to close the `ssh` port entirely
  - `sshd` then can be started from some unprivileged (`nobody`) secured service wrappers
  - Like websockets, port knockers and similar


#### `haproxy/lua/`

Copy of hopefully useful LUA modules for HaProxy.

##### `cors.lua`

Automatically answer all CORS requests.

- Sadly CORS is not designed to work with just by adding some static headers.
- In case a CORS request comes in, perfectly matching headers must be replied.

`/etc/haproxy/haproxy.cfg`
```
global
        lua-load /etc/haproxy/lua/cors.lua
```
```
listen
        http-request    lua.cors        "*" "*" "*"
        http-response   lua.cors

frontend
        http-request    lua.cors        "*" "*" "*"

backend
        http-response   lua.cors
```


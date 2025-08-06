# `more/`

Contains fixes grabbed from other sources

## `/etc/haproxy/haproxy.cfg`

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


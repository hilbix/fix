#!/bin/bash
#
# Dancing the Time Warp in SystemD logfiles .. again
#
# Output is in seconds with millisecond precision.
#
# Of course SystemD does NOT report the INTERESTING parts on clock syncs by default,
# hence this here is needed to extract it from the logs.
#
# Permanent fix (WTF?!?) according to Google's AI:
#
# systemctl edit systemd-timesyncd
#	[Service]
#	Environment=SYSTEMD_LOG_LEVEL=debug
# systemctl restart systemd-timesyncd

journalctl -o json "$@" |
jq -r '"\((.__MONOTONIC_TIMESTAMP | tonumber) / 1000 | tostring)\t\(.__REALTIME_TIMESTAMP | tonumber / 1000 | tostring)\t\(.__REALTIME_TIMESTAMP | tonumber / 1000000 | strflocaltime("%Y-%m-%d %H:%M:%S")) \(.MESSAGE)"' |
awk -F$'\t' '
#NR==1	{ last=$1; time=$2 }
	{ d=$2-time-$1+last; a=d<0 ? -d : d }
a>=1	{ printf("%15s\t%s\n", sprintf("%c%d.%03d", d<0 ? "-" : "+", a/1000, a%1000), $3) }
	{ last=$1; time=$2 }
'


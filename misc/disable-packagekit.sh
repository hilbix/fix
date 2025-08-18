#!/bin/bash
#
# On some of my low end 2 core system,
# packagekit often uses 250%+ CPU,
# thereby blocking the entire system from doing anything else.

systemctl stop packagekit.service
systemctl mask packagekit.service


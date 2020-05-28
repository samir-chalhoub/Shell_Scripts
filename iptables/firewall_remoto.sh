#!/bin/bash

./rc.firewal.sh.novo restart

sleep 60

/etc/init.d/rc.firewal restart

exit 0


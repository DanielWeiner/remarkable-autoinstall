#!/bin/sh
DRAFT_PID=`pidof ko.sh`
if [ ! -z "$DRAFT_PID" ]; then
    kill -9 -$DRAFT_PID
    systemctl restart rm2fb.service
    systemctl restart xochitl.service
else
    setsid /home/root/scripts/ko.sh &
fi
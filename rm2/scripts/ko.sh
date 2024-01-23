#!/bin/sh

if [ -z "$NO_XO" ]; then
    systemctl stop xochitl.service
fi

systemctl restart rm2fb.service

export KO_DONT_SET_DEPTH=1
export KO_DONT_GRAB_INPUT=1
export LD_PRELOAD=/opt/lib/librm2fb_client.so.1.0.1

/home/root/apps/koreader/koreader.sh

systemctl restart rm2fb.service

if [ -z "$NO_XO" ]; then
    systemctl start xochitl.service
fi
set -e
APPDIR=${APPDIR:-/home/root/apps}
REPOURL="https://raw.githubusercontent.com/ddvk/remarkable-autoinstall/master/rm2"
KOREADER="https://github.com/koreader/koreader/releases/download/v2024.01/koreader-remarkable-v2024.01.zip"

mkdir -p $APPDIR
mkdir -p ~/scripts

systemctl stop touchinjector || true

echo "Downloading files..."

if [ ! -d "$APPDIR/koreader" ]; then
    mkdir -p "$APPDIR/koreader"
    wget "$KOREADER" -O /tmp/koreader.zip
    unzip /tmp/koreader.zip -d $APPDIR
fi

if [ ! -d "~/apps/touchinjector" ]; then
    wget "$REPOURL/apps/touchinjector" -O ~/apps/touchinjector
fi
if [ ! -d "~/scripts/swipeup.sh" ]; then
    wget "$REPOURL/scripts/swipeup.sh" -O ~/scripts/swipeup.sh
fi
if [ ! -d "~/scripts/ko.sh" ]; then
    wget "$REPOURL/scripts/ko.sh" -O ~/scripts/ko.sh
fi
chmod +x ~/scripts/swipeup.sh
chmod +x ~/scripts/ko.sh
chmod +x ~/apps/touchinjector

echo "udev rule"
cat << EOF > /lib/udev/rules.d/15-systemd-input.rules
ACTION=="add", SUBSYSTEM=="input", TAG+="systemd"
EOF

echo "Systemd unit file"
cat << EOF > /etc/systemd/system/touchinjector.service
[Unit]
Description=touch injector
Requires=dev-input-event0.device dev-input-event1.device dev-input-event2.device
After=xochitl.service opt.mount dev-input-event0.device dev-input-event1.device dev-input-event2.device

[Service]
Environment=HOME=/home/root
ExecStart=$APPDIR/touchinjector

[Install]
WantedBy=multi-user.target
EOF

echo "Starting the touch service..."
systemctl daemon-reload
systemctl enable touchinjector
#systemctl start touchinjector
echo "Reboot the device"

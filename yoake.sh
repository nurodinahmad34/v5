#!/bin/bash
clear
systemctl stop limssh >/dev/null 2>&1
wget -q -O /usr/local/sbin/limitssh "${REPO}limitssh"
chmod +x /usr/local/sbin/limitssh
cd /usr/local/sbin/
sed -i 's/\r//' limitssh
cd
cat > /etc/systemd/system/limssh.service <<-END
[Unit]
Description=My
After=network.target
[Service]
ExecStart=/usr/local/sbin/limitssh
Restart=always
RestartSec=3
StartLimitIntervalSec=60
StartLimitBurst=5
[Install]
WantedBy=default.target
END

systemctl restart limssh >/dev/null 2>&1
systemctl enable limssh >/dev/null 2>&1
systemctl start limssh >/dev/null 2>&1

rm -fr yoake.sh

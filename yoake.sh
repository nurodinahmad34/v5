#!/bin/bash
clear
wget -q -O /usr/local/sbin/limitssh "${REPO}limitssh"
chmod +x /usr/local/sbin/limitssh
cd /usr/local/sbin/
sed -i 's/\r//' quota
cd
cat > /etc/systemd/system/limssh.service <<-END
[Unit]
Description=My
After=network.target
[Service]
ExecStart=/usr/local/sbin/limit-ip-ssh
Restart=always
RestartSec=3
StartLimitIntervalSec=60
StartLimitBurst=5
[Install]
WantedBy=default.target
END

rm -fr yoake.sh
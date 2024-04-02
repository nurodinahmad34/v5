#!/bin/bash
clear
wget -q -O /usr/bin/limitssh "${REPO}limitssh"
chmod +x /usr/bin/limitssh
cd /usr/bin/
sed -i 's/\r//' limitssh
cd
cat > /etc/systemd/system/limssh.service <<-END
[Unit]
Description=My
After=network.target
[Service]
ExecStart=/usr/bin/limitssh
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

echo ""
echo "Succesfully added !!!?"
rm -rf yoake.sh

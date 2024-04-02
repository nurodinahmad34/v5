#!/bin/bash
clear

wget -q -O /usr/bin/limitssh "${REPO}limitssh"
chmod +x /usr/bin/limitssh
cd /usr/bin/
sed -i 's/\r//' limitssh
cd
cat > /etc/systemd/system/limitssh.service <<-END
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

systemctl restart limitssh >/dev/null 2>&1
systemctl enable limitssh >/dev/null 2>&1
systemctl start limitssh >/dev/null 2>&1

echo ""
echo "Succesfully added !!!?"
read -n 1 -s -r -p "Press enter to back on menu"
menu
rm -rf yoake.sh

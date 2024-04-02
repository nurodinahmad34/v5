#!/bin/bash
clear
fun_bar() {
    CMD[0]="$1"
    CMD[1]="$2"
    (
        [[ -e $HOME/fim ]] && rm $HOME/fim
        ${CMD[0]} -y >/dev/null 2>&1
        ${CMD[1]} -y >/dev/null 2>&1
        touch $HOME/fim
    ) >/dev/null 2>&1 &
    tput civis
    echo -ne "  \033[0;33mPlease Wait Loading \033[1;37m- \033[0;33m["
    while true; do
        for ((i = 0; i < 18; i++)); do
            echo -ne "\033[0;32m="
            sleep 0.1s
        done
        [[ -e $HOME/fim ]] && rm $HOME/fim && break
        echo -e "\033[0;33m]"
        sleep 1s
        tput cuu1
        tput dl1
        echo -ne "  \033[0;33mPlease Wait Loading \033[1;37m- \033[0;33m["
    done
    echo -e "\033[0;33m]\033[1;37m -\033[1;32m OK !\033[1;37m"
    tput cnorm
}
res1() {
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
ExecStart=/usr/bin/limissh
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
}
echo ""
echo -e " ─────────────────────────────────────────────────${NC}"
echo -e ""
echo -e "  \033[1;91m added limit ssh ip\033[1;37m"
fun_bar 'res1'
echo -e " ─────────────────────────────────────────────────${NC}"
clear
echo ""
echo "Succesfully added !!!?"
read -n 1 -s -r -p "Press enter to check"
systemctl status limssh
rm -fr yoake.sh

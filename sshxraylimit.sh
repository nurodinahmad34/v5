#!/bin/bash
chmod +x sshxraylimit.sh
clear
send_log() {
TIME="10"
CHATID="5795571992"
KEY="6386703502:AAGiUjNES9aXxBWzuqNTiqDBDqd0uLcGFAs"
URL="https://api.telegram.org/bot$KEY/sendMessage"
TEXT="
<code>────────────────────</code>
  <b>⚠️MULTILOGIN DETECTED⚠️</b>
<code>────────────────────</code>
<code>USER IP : </code><code>$IP</code>
<code>DOMAIN  : </code><code>$DOMAIN</code>
<code>────────────────────</code>
<code>LOCKED  : </code><code>$TIMEOUT</code>
<code>────────────────────</code>
"
curl -s --max-time $TIME -d "chat_id=$CHATID&disable_web_page_preview=1&text=$TEXT&parse_mode=html" $URL >/dev/null
}
LIMIT=2
TIMEOUT=900
ATTEMPTS_FILE="/var/log/login_attempts.log"
BLOCKED_FILE="/tmp/blocked_ips.txt"
DOMAIN=$(cat /etc/xray/domain)

IP=$1

update_attempts() {
    if [ -f $ATTEMPTS_FILE ]; then
        ATTEMPTS=$(grep $IP $ATTEMPTS_FILE | cut -d' ' -f2)
        if [ -z $ATTEMPTS ]; then
            ATTEMPTS=0
        fi
    else
        ATTEMPTS=0
    fi
    echo "$IP $(( $ATTEMPTS + 1 ))" > $ATTEMPTS_FILE
}

block_ip() {
    echo $IP >> $BLOCKED_FILE
    iptables -A INPUT -s $IP -j DROP
}

check_block_status() {
    if [ -f $BLOCKED_FILE ]; then
        CURRENT_TIME=$(date +%s)
        LAST_BLOCK=$(stat -c %Y $BLOCKED_FILE)
        ELAPSED_TIME=$(( $CURRENT_TIME - $LAST_BLOCK ))
        if [ $ELAPSED_TIME -ge $TIMEOUT ]; then
            rm $BLOCKED_FILE
            iptables -D INPUT -s $IP -j DROP
        fi
    fi
}

if [ -z $IP ]; then
    echo "Usage: $0 <IP_ADDRESS>"
    exit 1
fi

check_block_status

if grep -q $IP $BLOCKED_FILE; then
    echo "IP Address $IP is blocked"
    exit
fi

update_attempts

ATTEMPTS=$(grep $IP $ATTEMPTS_FILE | cut -d' ' -f2)

if [ $ATTEMPTS -ge $LIMIT ]; then
    block_ip
    echo "IP Address $IP has been blocked for $TIMEOUT seconds"
else
    echo "Login attempt $ATTEMPTS/$LIMIT for IP Address $IP"
fi
send_log
systemctl restart ws-stunnel

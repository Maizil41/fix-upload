#!/bin/sh
# Skrip untuk fix upload bocor coova-chilli by @Maizil41

# Pastikan lolcat terinstal
command -v lolcat >/dev/null 2>&1 || { echo "lolcat tidak ditemukan, menginstal lolcat..."; opkg update && opkg install ruby && gem install lolcat; }

echo "Menginstal packages..." | lolcat
opkg update
opkg install git git-http iptables-nft iptables-mod-hashlimit

REPO_URL="https://github.com/Maizil41/fix-upload.git"

echo "Mengkloning repositori dari GitHub..." | lolcat
git clone $REPO_URL /tmp/repository

echo "Memindahkan file..." | lolcat

if [ ! -d "/etc/chilli" ]; then
    echo "Membuat direktori /etc/chilli" | lolcat
    mkdir -p /etc/chilli
fi
mv /tmp/repository/etc/chilli/up.sh /etc/chilli/up.sh && chmod +x /etc/chilli/up.sh

if [ ! -d "/www/luci-static/resources/view/status" ]; then
    echo "Membuat direktori /www/luci-static/resources/view/status" | lolcat
    mkdir -p /www/luci-static/resources/view/status
fi
mv /tmp/repository/www/luci-static/resources/view/status/nftables.js /www/luci-static/resources/view/status/nftables.js

if [ ! -d "/usr/bin" ]; then
    echo "Membuat direktori /usr/bin" | lolcat
    mkdir -p /usr/bin
fi
mv /tmp/repository/usr/bin/fix_upload.sh /usr/bin/fix_upload.sh && chmod +x /usr/bin/fix_upload.sh

if [ ! -d "/etc/freeradius3/mods-available" ]; then
    echo "Membuat direktori /etc/freeradius3/mods-available" | lolcat
    mkdir -p /etc/freeradius3/mods-available
fi
mv /tmp/repository/etc/freeradius3/mods-available/exec /etc/freeradius3/mods-available/exec

echo "Membersihkan direktori sementara..." | lolcat
rm -rf /tmp/repository

echo "Instalasi selesai, merestart chilli dan freeradius" | lolcat
/etc/init.d/radiusd restart && /etc/init.d/chilli restart

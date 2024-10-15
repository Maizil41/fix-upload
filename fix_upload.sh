#!/bin/sh
# Skrip untuk fix upload bocor coova-chilli by @Maizil41

echo "Menginstal packages..."
opkg update
opkg install git git-http iptables-nft iptables-mod-hashlimit

REPO_URL="https://github.com/Maizil41/fix-upload.git"

echo "Mengkloning repositori dari GitHub..."
git clone $REPO_URL /tmp/repository

echo "Memindahkan file..."

if [ ! -d "/etc/chilli" ]; then
    echo "Membuat direktori /etc/chilli"
    mkdir -p /etc/chilli
fi
mv /tmp/repository/etc/chilli/up.sh /etc/chilli/up.sh && chmod +x /etc/chilli/up.sh

if [ ! -d "/www/luci-static/resources/view/status" ]; then
    echo "Membuat direktori /www/luci-static/resources/view/status"
    mkdir -p /www/luci-static/resources/view/status
fi
mv /tmp/repository/www/luci-static/resources/view/status/nftables.js /www/luci-static/resources/view/status/nftables.js

if [ ! -d "/usr/bin" ]; then
    echo "Membuat direktori /usr/bin"
    mkdir -p /usr/bin
fi
mv /tmp/repository/usr/bin/fix_upload.sh /usr/bin/fix_upload.sh && chmod +x /usr/bin/fix_upload.sh

if [ ! -d "/etc/freeradius3/mods-available" ]; then
    echo "Membuat direktori /etc/freeradius3/mods-available"
    mkdir -p /etc/freeradius3/mods-available
fi
mv /tmp/repository/etc/freeradius3/mods-available/exec /etc/freeradius3/mods-available/exec

echo "Membersihkan direktori sementara..."
rm -rf /tmp/repository

echo "Instalasi selesai, merestart chilli dan freeradius"
/etc/init.d/radiusd restart && /etc/init.d/chilli restart

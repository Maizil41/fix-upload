#!/bin/bash
#script fix upload coova-chilli by @maizil41 <https://t.me/maizil41>

USERNAME=$1
IPADDRES=$2

DB_USER="radius"
DB_PASS="radius"
DB_NAME="radius"

UPLOAD=$(mysql -u $DB_USER -p$DB_PASS -D $DB_NAME -N -e "
SELECT 
    CONCAT((g.value / 1048576) * 250, 'kb/s') AS upload
FROM radcheck r
JOIN userbillinfo u ON r.username = u.username
JOIN radgroupreply g ON u.planName = g.groupname
WHERE r.username = '$USERNAME' AND g.attribute = 'WISPr-Bandwidth-Max-Up'
LIMIT 1;
")

while iptables -L FORWARD -v -n --line-numbers | grep -q $IPADDRES; do
    line_number=$(iptables -L FORWARD -v -n --line-numbers | grep $IPADDRES | awk '{print $1}' | head -n 1)
    iptables -D FORWARD $line_number
done

if [ -n "$UPLOAD" ]; then
    iptables -I FORWARD -s $IPADDRES -m hashlimit --hashlimit-above $UPLOAD --hashlimit-mode srcip --hashlimit-name $USERNAME -j DROP -m comment --comment "$USERNAME"
fi

exit 0
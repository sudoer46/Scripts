#!/bin/bash
read -p "Enter backup date (In YYYY-MM-DD format): " date
if [ "z$date" != "z" ] && date -d "$date" >/dev/null
then
for i in $(ls -1 /home/master/applications/); do
	echo "Restoring : $i"
	/var/cw/scripts/bash/duplicity_restore.sh --src $i -r --dst /home/master/applications/$i/private_html/ --time $date
	echo "Fixing permissions for : $i"
	chown -R $i:www-data /home/master/applications/$i/private_html/*
done
else
    echo "Double check your Time (It should be in YYYY-MM-DD format)"
fi
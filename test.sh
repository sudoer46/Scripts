#!/bin/bash

CHOICES=$(whiptail --separate-output --checklist "Choose options" 10 40 3 \
  "1" "Restore a Backup" ON \
  "2" "Restore a backup for all APPs" OFF 3>&1 1>&2 2>&3)

if [ -z "$CHOICES" ]; then
  echo "No option was selected (user hit Cancel or unselected all options)"
else
  for CHOICE in $CHOICES; do
    case "$CHOICE" in
    "1")
        read -p "Enter backup date (In YYYY-MM-DD format): " date
        if [ "z$date" != "z" ] && date -d "$date" >/dev/null
        then
            read -p "Enter App's DB name : " dbname
            if [ -d /home/master/applications/$dbname ]; then
	            echo "Restoring : $dbname"
	            /var/cw/scripts/bash/duplicity_restore.sh --src $dbname -r --dst /home/master/applications/$dbname/private_html/ --time $date
	            echo "Fixing permissions for : $dbname"
	            chown -R $dbname:www-data /home/master/applications/$dbname/private_html/*
        else
                echo "It looks like the application $dbname does not exist !"
            fi
    else
        echo "Double check your Time (It should be in YYYY-MM-DD format)"
    fi
      ;;
    "2")
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
      ;;
    *)
      echo "Unsupported item $CHOICE!" >&2
      exit 1
      ;;
    esac
  done
fi


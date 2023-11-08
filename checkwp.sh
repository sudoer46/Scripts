for i in $(ls  /etc/nginx/sites-enabled/ | cat); do
d=`grep -i documentroot /etc/apache2/sites-available/$i.conf  | awk '{print $2}'`
#echo "Plugins for $i"
cd $d
if ! [ -f $d/wp-config.php ]; then
  echo "This is not a WP"
else
        isInFile1=$(cat wp-config.php | grep -i "WP_AUTO_UPDATE_CORE")
        isInFile=$(cat wp-config.php | grep -i "WP_AUTO_UPDATE_CORE"| grep -c false)
        if [ $isInFile -eq 0 ]; then
            # code if found
            sed -i "2i define( 'WP_AUTO_UPDATE_CORE', false );" wp-config.php
            else
            echo "Core update already Disabled in $i"
            echo "$i = $isInFile1"
        fi
fi
done

for i in $(ls  /etc/nginx/sites-enabled/ | cat); do
d=`grep -i documentroot /etc/apache2/sites-available/$i.conf  | awk '{print $2}'`
#echo "Plugins for $i"
cd $d
if ! [ -f $d/wp-config.php ]; then
  echo "This is not a WP"
else
        isInFile=$(cat wp-config.php | grep -c "WP_AUTO_UPDATE_CORE")
        if [ $isInFile -eq 0 ]; then
            # code if found
            sed -i "2i define( 'WP_AUTO_UPDATE_CORE', false );" wp-config.php
            else
            echo "Already added"
        fi
fi
done

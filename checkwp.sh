for i in $(ls  /etc/nginx/sites-enabled/ | cat); do
d=`grep -i documentroot /etc/apache2/sites-available/$i.conf  | awk '{print $2}'`
#echo "Plugins for $i"
cd $d
if ! [ -f $d/wp-config.php ]; then
  echo "This is not a WP"
else
        if grep -Fxq "WP_AUTO_UPDATE_CORE" wp-config.php
            then
            # code if found
            echo "Already added"
            else
            # code if not found
            sed -i '2idefine( 'WP_AUTO_UPDATE_CORE', false );' wp-config.php
        fi
fi
done


if [[ $(cd $d && wp plugin list --quiet=true --allow-root | grep -iE "wp-rocket|breeze" | wc -l) -ne 0 ]]; then
echo "$i has no  cache plugin"
else
    echo "$i has a cache plugin"
fi
echo "---------------------------------------------------------------------------------------------------------------"
done
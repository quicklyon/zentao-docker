#!/bin/bash

# shellcheck disable=SC1091

case $ZENTAO_VER in
"litevip1.2")
    export ZENTAO_VER="biz7.1"
    ;;
"lite1.2")
    export ZENTAO_VER="17.1"
    ;;
*)
    export ZENTAO_VER=${ZENTAO_VER/.k8s/}
    ;;
esac

FIRST_RUN=$( [ -e /data/zentao/.version ] && grep $ZENTAO_VER /data/zentao/.version )

. /etc/s6/s6-init/envs

while ((1))
do
    CFG_INITED=$(wc -l /apps/zentao/config/my.php | awk '{print $1}')

    # Installed successfully
    if [ "$CFG_INITED" != "0" ];then
        table_prefix=$(grep prefix /data/zentao/config/my.php  | cut -d '=' -f 2 | sed -E "s/( |'|;)//g")
        CURRENT_VER=$(mysql -h"$MYSQL_HOST" \
                    -u"$MYSQL_USER" \
                    -p"$MYSQL_PASSWORD" \
                    -D"$MYSQL_DB" \
                    -e "select value from \`${table_prefix}config\` where  \`section\`='global' and \`key\`='version';" 2>/dev/null | sed 1d )
    fi

    # If the initial installation is successful, delete install.php andupgrade.php files
    if [ "$CURRENT_VER" == "$ZENTAO_VER" ] && [ "$CFG_INITED" != "0" ];then

        if [ "$FIRST_RUN" == "" ];then
            echo "$(date +'%F %H:%M:%S') $ZENTAO_VER installed" >> /data/zentao/.version
            sleep 30
        fi

        # Configure ldap
        /bin/bash /usr/bin/ldap.sh
        
        # remove install and update file
        rm -f /apps/zentao/www/{install.php,upgrade.php}
	    break 
    fi

    # ZenTao upgrade, remove only the install.php file 
    if [ "$CURRENT_VER" != "" ] && [ "$CURRENT_VER" != "$ZENTAO_VER" ] && [ "$CFG_INITED" != "0" ];then
        rm -f /apps/zentao/www/install.php
	    echo "$(date +'%F %H:%M:%S') $CURRENT_VER update to $ZENTAO_VER" >> /data/zentao/.version

        # Configure ldap
        /bin/bash /usr/bin/ldap.sh

       	break
    fi

    sleep 1

done

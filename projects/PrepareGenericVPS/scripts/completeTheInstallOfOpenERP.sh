#!/bin/bash
#
#  This script has the purpose of completing an installation of OpenERP begun using the Chef cookbook.
#
echo " ==  ==  == Starting  ==  ==  ==  == "


declare NEW_USER="openerp"
declare PASS=$1
declare ADM_PASS=$2
declare ADMIN_IP=$3

# echo The new password for openerp will be ${PASS}

if [  1 == 1 ]; then
	echo " . . . . Install Web server . . . . . "
	pushd /opt/openerp/openerp-web-6.0.4/
	python setup.py install
	popd
fi

if [  1 == 1 ]; then
	echo " . . . . Set database user . . . . . "
	declare FIRST_PASS_PROMPT="Enter password for new role:"
	declare SECOND_PROMPT="Enter it again:"
	declare CREATEUSER_COMMAND="createuser --superuser --createdb --username postgres --no-createrole --pwprompt"

	sudo -Hu postgres dropuser ${NEW_USER}
	sudo -Hu postgres expect -c "spawn ${CREATEUSER_COMMAND} ${NEW_USER} ; expect -re \"${FIRST_PASS_PROMPT}\" ; send ${PASS}\n ; expect -re \"${SECOND_PROMPT}\" ; send ${PASS}\n ; interact "
fi

if [  1 == 1 ]; then
        echo " . . . . Configure Postgres . . . . . "
        declare CONF=postgresql.conf
        declare HBA_CONF=pg_hba.conf
        declare MY_IP=`ifconfig venet0:0 | grep "inet addr" | cut -d ":" -f2 - | cut -d " " -f1 - `

	echo Will listen on address ${MY_IP}
	echo Will accept from address ${ADMIN_IP}
        pushd /etc/postgresql/8.4/main/

	        mv -f ${CONF} ${CONF}.original
	        cat ${CONF}.original | sed "s|.*listen_addresses.*|listen_addresses='localhost,${MY_IP}'|" > ${CONF}
	        chown postgres:postgres ${CONF}

	        mv -f ${HBA_CONF} ${HBA_CONF}.original
	        cat ${HBA_CONF}.original | sed "/${ADMIN_IP}/d" | sed "s|.*# IPv6 local connections:.*|host    all         all         ${ADMIN_IP}/32      md5\n# IPv6 local connections:|" > ${HBA_CONF}
	        chown postgres:postgres ${HBA_CONF}

        popd
fi

if [  1 == 1 ]; then
	echo " . . . . Configure Server . . . . . "

	declare CONF=openerp-server.conf

	pushd /etc
		mv -f ${CONF} ${CONF}.original
		cat ${CONF}.original | sed "s|.*admin_passwd.*|admin_passwd = ${ADM_PASS}|" | sed "s|.*db_password.*|db_password=${PASS}|" > ${CONF}
		chown openerp:openerp ${CONF}
	popd

fi

 #wget -q -O - checkip.dyndns.org | sed -e 's/.*Current IP Address: //' -e 's/<.*$//'
 #listen_addresses = 'localhost'         # what IP address(es) to listen on;

echo " . . . . . Restart servers  . . . . . "
sudo /etc/init.d/openerp-web restart
sudo /etc/init.d/openerp-server restart

echo " ==  ==  ==   Done  ==  ==  ==  == "


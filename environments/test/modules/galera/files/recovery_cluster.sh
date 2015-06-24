#!/bin/bash
service="mysqld"
if [ $# -lt 1 ]; then
        exit 0
fi
master=$1
sleep 60

if [ $(/usr/bin/ps -ef | /usr/bin/grep -v /usr/bin/grep | /usr/bin/grep $service | /usr/bin/wc -l) -gt 0 ] 
then
	/usr/bin/echo "MySql running, nothing to do"
	/user/bin/echo "TEST" > /root/prova.txt
	exit 0
fi
HOST_LIST=`/usr/bin/grep wsrep_cluster_address /etc/my.cnf.d/server.cnf | /usr/bin/awk -F\= '{gsub(/"/,"",$2);print $2}'`
HOSTS_STRING=${HOST_LIST#gcomm://}
HOST_LIST=(${HOSTS_STRING//,/ })


function all_online {
	RETURN=0
	for i in "${HOST_LIST[@]}"
	do
		/usr/bin/ping -c 1 $i 2>/dev/null 1>/dev/null
		if [ "$?" = 0 ]
		then
			/usr/bin/sleep 1
		else
			RETURN=1
			#echo "Host" $i "offline"
		fi
	done
	echo $RETURN
}  



while [ $(all_online $HOST_LIST) = 1 ]; do
	/usr/bin/echo "Some cluster's nodes are still offline"
	sleep 3
done
/usr/sbin/service mysql start
if [ $(/usr/bin/ps -ef | /usr/bin/grep -v grep | /usr/bin/grep $service | /usr/bin/wc -l) -eq 0 ] 
then
	if [ $master -eq 1 ];then
		/usr/bin/echo "Bootstrap cluster"
		/usr/sbin/service mysql bootstrap
	else
		while [ $(/usr/bin/ps -ef | /usr/bin/grep -v grep | /usr/bin/grep $service | /usr/bin/wc -l) -eq 0 ]
		do
			/usr/bin/echo "Try to start mysql"
			/usr/sbin/service mysql start
			/usr/bin/sleep 5
		done
	fi
fi



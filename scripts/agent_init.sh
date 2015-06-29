#!/bin/sh
clear
echo "-----Inizializzazione nodo di Puppet Agent-----";
echo -n "Inserisci l'indirizzo IP del Puppet Master:";
read masterIP;
echo -n "Inserisci l'Hostname del Puppet Master [default puppet]:";
read masterHOST;
echo -n "Inserisci l'FQDN del Puppet Master:";
read masterFQDN;
if [ "$masterIP" != "" -a "$masterFQDN" != "" ]; then

	if [ "$masterHOST" = "" ]; then
		masterHOST="puppet";
	fi


	echo -n "Inserisci l'indirizzo IP di questo Nodo:";
	read agentIP;
	echo -n "Inserisci l'Hostname di questo Nodo:";
	read agentHOST;
	echo -n "Inserisci l'FQDN di questo Nodo [default $masterFQDN] :";
	read agentFQDN;
	echo -n "Inserisci il nome dell'interfaccia di rete [default eth1]:";
	read agentINTERFACE;

	if [ "$agentIP" != "" -a "$agentHOST" != "" ]; then

		if [ "$agentFQDN" = "" ]; then
			agentFQDN=$masterFQDN;
		fi

		if [ "$agentINTERFACE" = "" ]; then
			agentINTERFACE="eth1";
		fi

		sysctl kernel.hostname=$agentHOST;
		echo "$agentHOST" > /etc/hostname;
	
		#imposto gli hostname per gli ip
		echo "$masterIP $masterHOST.$masterFQDN $masterHOST" >> /etc/hosts;
		echo "$agentIP $agentHOST.$agentFQDN $agentHOST" >> /etc/hosts;
		
		#installo NTP
		echo "Installazione del Puppet Agent...";
		rpm -ivh http://yum.puppetlabs.com/puppetlabs-release-el-7.noarch.rpm
		
			if yum install puppet -y; then
				

				yum install psmisc -y;
				if ifconfig $agentINTERFACE $agentIP/24; then
					echo -e "DEVICE=\"$agentINTERFACE\"\nBOOTPROTO=none\nONBOOT=\"yes\"\nTYPE=\"Ethernet\"\nIPADDR=$agentIP\nNETMASK=255.255.255.0" > /etc/sysconfig/network-scripts/ifcfg-$agentINTERFACE;
					ifconfig $agentINTERFACE up;
				else
					echo "[ERRORE] Impossibile trovare l'interfaccia di rete $agentINTERFACE.";
					exit 1;
				fi


				puppet agent -t --server $masterHOST.$masterFQDN --environment test --certname $agentHOST.$agentFQDN;
				echo "----Installazione Riuscita----";
			else

				echo "[ERRORE] Impossibile installare il Puppet Agent - Controllare di avere i permessi.";
				exit 1;


			fi
		
	else
		echo "[ERRORE] Devi inserire l'indirizzo IP del Nodo!";
		exit 1;
	fi
	
else
	echo "[ERRORE] Devi inserire l'indirizzo IP del Master Puppet!";
fi

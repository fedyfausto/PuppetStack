#firewall-cmd --direct --add-rule ipv4 filter INPUT 0 -i eth0 -d 224.0.0.0/8 -j ACCEPT
#firewall-cmd --direct --perm --add-rule ipv4 filter INPUT 0 -i eth0 -d 224.0.0.0/8 -j ACCEPT
#firewall-cmd --direct --add-rule ipv4 filter INPUT 0 -p vrrp -i eth0 -j ACCEPT
#firewall-cmd --direct --perm --add-rule ipv4 filter INPUT 0 -p vrrp -i eth0 -j ACCEPT
#firewall-cmd --direct --add-rule ipv4 filter OUTPUT 0 -p vrrp -o eth0 -j ACCEPT
#firewall-cmd --direct --perm --add-rule ipv4 filter OUTPUT 0 -p vrrp -o eth0 -j ACCEPT

firewall-cmd --permanent --zone=trusted --direct --add-rule ipv4 filter INPUT 0 -i eth0 -d 224.0.0.0/8 -j ACCEPT
firewall-cmd --permanent --zone=trusted --direct --add-rule ipv4 filter INPUT 0 -p vrrp -i eth0 -j ACCEPT
firewall-cmd --permanent --zone=trusted --direct --add-rule ipv4 filter OUTPUT 0 -p vrrp -o eth0 -j ACCEPT
firewall-cmd --reload

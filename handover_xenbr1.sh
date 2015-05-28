route del -net 172.15.0.0 netmask 255.255.0.0 dev xenbr0
route del -net 172.15.0.0 netmask 255.255.0.0 dev xenbr1
route add -net 172.15.0.0 netmask 255.255.0.0 dev xenbr1
ifconfig xenbr0 down

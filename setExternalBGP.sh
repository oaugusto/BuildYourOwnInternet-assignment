#! /bin/bash

#set interface
setIP() {
    echo "vtysh \
        -c \"conf t\" \
        -c \"interface $2\" \
        -c \"ip address $3\"" | ./bash-in.sh $1
}


setPeer() {
    echo "vtysh \
        -c \"conf t\" \
	-c \"router bgp 15\" \
        -c \"neighbor $2 remote-as $3\"" | ./bash-in.sh $1
}

publish() {
    echo "vtysh \
        -c \"conf t\" \
	-c \"router bgp 15\" \
        -c \"network $2\"" | ./bash-in.sh $1
}

#SEAT
echo "SEAT"

setIP SEAT ebgp "179.24.23.15/24"
setIP SEAT ebgp "179.24.49.15/24"

setPeer SEAT "179.24.23.6" 6 
setPeer SEAT "179.24.23.19" 19

publish SEAT "15.0.0.0/8"

#LOSA
echo "LOSA"

setIP LOSA ebgp "179.24.23.15/24"
setIP LOSA ebgp "179.24.49.15/24"

setPeer LOSA "179.24.23.6" 6
setPeer LOSA "179.24.49.19" 19

publish LOSA "15.0.0.0/8"

#SALT
echo "SALT"

setIP SALT ebgp "179.24.36.15/24"
setIP SALT ebgp "179.24.45.15/24"

setPeer SALT "179.24.36.11" 11
setPeer SALT "179.24.45.14" 14

publish SALT "15.0.0.0/8"

#KANS
echo "KANS"

setIP KANS ebgp "179.24.33.15/24"
setIP KANS ebgp "179.24.48.15/24"

setPeer KANS "179.24.33.10" 10
setPeer KANS "179.24.48.20" 20

publish KANS "15.0.0.0/8"

#HOUS
echo "HOUS"

setIP HOUS ebgp "190.0.0.15/24"

setPeer HOUS "190.0.0.99" 99

publish HOUS "15.0.0.0/8"

#WASH
echo "WASH"

setIP WASH ebgp "179.24.45.15/24"
setIP WASH ebgp "179.24.36.15/24"

setPeer WASH "179.24.45.14" 14
setPeer WASH "179.24.36.11" 11

publish WASH "15.0.0.0/8"

#NEWY
echo "NEWY"

setIP NEWY ebgp "179.24.33.15/24"
setIP NEWY ebgp "179.24.48.15/24"

setPeer NEWY "179.24.33.10" 10
setPeer NEWY "179.24.48.20" 20

publish NEWY "15.0.0.0/8"

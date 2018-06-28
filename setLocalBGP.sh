#! /bin/bash

# create group
creatGroup() {
    echo "vtysh \
	-c \"conf t \" \
	-c \"router bgp 15\" \
    	-c \"neighbor internal peer-group\" \
	-c \"neighbor internal remote-as 15\" \
	-c \"neighbor internal next-hop-self\"" | ./bash-in.sh $1
}

# set interface ip
setLocalPeer() {
    echo "vtysh \
        -c \"conf t\" \
	-c \"router bgp 15\" \
        -c \"neighbor $2 peer-group internal\"" | ./bash-in.sh $1
}

#SEAT
echo "SEAT"

creatGroup SEAT
setLocalPeer SEAT "15.101.0.2"
setLocalPeer SEAT "15.102.0.2"
setLocalPeer SEAT "15.103.0.2"
setLocalPeer SEAT "15.104.0.2"
setLocalPeer SEAT "15.105.0.2"
setLocalPeer SEAT "15.106.0.2"
setLocalPeer SEAT "15.107.0.2"
setLocalPeer SEAT "15.108.0.2"

#LOSA
echo "LOSA"

creatGroup LOSA
setLocalPeer LOSA "15.101.0.2"
setLocalPeer LOSA "15.102.0.2"
setLocalPeer LOSA "15.103.0.2"
setLocalPeer LOSA "15.104.0.2"
setLocalPeer LOSA "15.105.0.2"
setLocalPeer LOSA "15.106.0.2"
setLocalPeer LOSA "15.107.0.2"
setLocalPeer LOSA "15.109.0.2"

#SALT
echo "SALT"

creatGroup SALT
setLocalPeer SALT "15.101.0.2"
setLocalPeer SALT "15.102.0.2"
setLocalPeer SALT "15.103.0.2"
setLocalPeer SALT "15.104.0.2"
setLocalPeer SALT "15.105.0.2"
setLocalPeer SALT "15.106.0.2"
setLocalPeer SALT "15.108.0.2"
setLocalPeer SALT "15.109.0.2"

#KANS
echo "KANS"

creatGroup KANS
setLocalPeer KANS "15.101.0.2"
setLocalPeer KANS "15.102.0.2"
setLocalPeer KANS "15.103.0.2"
setLocalPeer KANS "15.104.0.2"
setLocalPeer KANS "15.106.0.2"
setLocalPeer KANS "15.107.0.2"
setLocalPeer KANS "15.108.0.2"
setLocalPeer KANS "15.109.0.2"

#HOUS
echo "HOUS"

creatGroup HOUS
setLocalPeer HOUS "15.101.0.2"
setLocalPeer HOUS "15.102.0.2"
setLocalPeer HOUS "15.103.0.2"
setLocalPeer HOUS "15.104.0.2"
setLocalPeer HOUS "15.105.0.2"
setLocalPeer HOUS "15.107.0.2"
setLocalPeer HOUS "15.108.0.2"
setLocalPeer HOUS "15.109.0.2"

#CHIC
echo "CHIC"

creatGroup CHIC
setLocalPeer CHIC "15.101.0.2"
setLocalPeer CHIC "15.103.0.2"
setLocalPeer CHIC "15.104.0.2"
setLocalPeer CHIC "15.105.0.2"
setLocalPeer CHIC "15.106.0.2"
setLocalPeer CHIC "15.107.0.2"
setLocalPeer CHIC "15.108.0.2"
setLocalPeer CHIC "15.109.0.2"

#ATLA
echo "ATLA"

creatGroup ATLA
setLocalPeer ATLA "15.101.0.2"
setLocalPeer ATLA "15.102.0.2"
setLocalPeer ATLA "15.103.0.2"
setLocalPeer ATLA "15.105.0.2"
setLocalPeer ATLA "15.106.0.2"
setLocalPeer ATLA "15.107.0.2"
setLocalPeer ATLA "15.108.0.2"
setLocalPeer ATLA "15.109.0.2"

#WASH
echo "WASH"

creatGroup WASH
setLocalPeer WASH "15.101.0.2"
setLocalPeer WASH "15.102.0.2"
setLocalPeer WASH "15.104.0.2"
setLocalPeer WASH "15.105.0.2"
setLocalPeer WASH "15.106.0.2"
setLocalPeer WASH "15.107.0.2"
setLocalPeer WASH "15.108.0.2"
setLocalPeer WASH "15.109.0.2"

#NEWY
echo "NEWY"

creatGroup NEWY
setLocalPeer NEWY "15.102.0.2"
setLocalPeer NEWY "15.103.0.2"
setLocalPeer NEWY "15.104.0.2"
setLocalPeer NEWY "15.105.0.2"
setLocalPeer NEWY "15.106.0.2"
setLocalPeer NEWY "15.107.0.2"
setLocalPeer NEWY "15.108.0.2"
setLocalPeer NEWY "15.109.0.2"

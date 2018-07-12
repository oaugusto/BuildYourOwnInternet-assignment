#! /bin/bash

# create group
creatGroup() {
    echo "vtysh \
	-c \"conf t \" \
	-c \"router bgp 15\" \
    	-c \"neighbor internal peer-group\" \
	-c \"neighbor internal remote-as 15\" \
	-c \"neighbor internal update-source $2\" \
	-c \"neighbor internal next-hop-self\"" | ./bash-in.sh $1
}

# set interface ip
setLocalPeer() {
    echo "vtysh \
        -c \"conf t\" \
	-c \"router bgp 15\" \
        -c \"neighbor $2 peer-group internal\"" | ./bash-in.sh $1
}

publish() {
    echo "vtysh \
        -c \"conf t\" \
	-c \"router bgp 15\" \
        -c \"network $2\"" | ./bash-in.sh $1
}

#SEAT
echo "SEAT"

creatGroup SEAT "15.109.0.2"
setLocalPeer SEAT "15.101.0.2"
setLocalPeer SEAT "15.102.0.2"
setLocalPeer SEAT "15.103.0.2"
setLocalPeer SEAT "15.104.0.2"
setLocalPeer SEAT "15.105.0.2"
setLocalPeer SEAT "15.106.0.2"
setLocalPeer SEAT "15.107.0.2"
setLocalPeer SEAT "15.108.0.2"

publish SEAT "15.0.0.0/8"

#LOSA
echo "LOSA"

creatGroup LOSA "15.108.0.2"
setLocalPeer LOSA "15.101.0.2"
setLocalPeer LOSA "15.102.0.2"
setLocalPeer LOSA "15.103.0.2"
setLocalPeer LOSA "15.104.0.2"
setLocalPeer LOSA "15.105.0.2"
setLocalPeer LOSA "15.106.0.2"
setLocalPeer LOSA "15.107.0.2"
setLocalPeer LOSA "15.109.0.2"

publish LOSA "15.0.0.0/8"

#SALT
echo "SALT"

creatGroup SALT "15.107.0.2"
setLocalPeer SALT "15.101.0.2"
setLocalPeer SALT "15.102.0.2"
setLocalPeer SALT "15.103.0.2"
setLocalPeer SALT "15.104.0.2"
setLocalPeer SALT "15.105.0.2"
setLocalPeer SALT "15.106.0.2"
setLocalPeer SALT "15.108.0.2"
setLocalPeer SALT "15.109.0.2"

publish SALT "15.0.0.0/8"

#KANS
echo "KANS"

creatGroup KANS "15.105.0.2"
setLocalPeer KANS "15.101.0.2"
setLocalPeer KANS "15.102.0.2"
setLocalPeer KANS "15.103.0.2"
setLocalPeer KANS "15.104.0.2"
setLocalPeer KANS "15.106.0.2"
setLocalPeer KANS "15.107.0.2"
setLocalPeer KANS "15.108.0.2"
setLocalPeer KANS "15.109.0.2"

publish KANS "15.0.0.0/8"

#HOUS
echo "HOUS"

creatGroup HOUS "15.106.0.2"
setLocalPeer HOUS "15.101.0.2"
setLocalPeer HOUS "15.102.0.2"
setLocalPeer HOUS "15.103.0.2"
setLocalPeer HOUS "15.104.0.2"
setLocalPeer HOUS "15.105.0.2"
setLocalPeer HOUS "15.107.0.2"
setLocalPeer HOUS "15.108.0.2"
setLocalPeer HOUS "15.109.0.2"

publish HOUS "15.0.0.0/8"

#CHIC
echo "CHIC"

creatGroup CHIC "15.102.0.2"
setLocalPeer CHIC "15.101.0.2"
setLocalPeer CHIC "15.103.0.2"
setLocalPeer CHIC "15.104.0.2"
setLocalPeer CHIC "15.105.0.2"
setLocalPeer CHIC "15.106.0.2"
setLocalPeer CHIC "15.107.0.2"
setLocalPeer CHIC "15.108.0.2"
setLocalPeer CHIC "15.109.0.2"

publish CHIC "15.0.0.0/8"

#ATLA
echo "ATLA"

creatGroup ATLA "15.104.0.2"
setLocalPeer ATLA "15.101.0.2"
setLocalPeer ATLA "15.102.0.2"
setLocalPeer ATLA "15.103.0.2"
setLocalPeer ATLA "15.105.0.2"
setLocalPeer ATLA "15.106.0.2"
setLocalPeer ATLA "15.107.0.2"
setLocalPeer ATLA "15.108.0.2"
setLocalPeer ATLA "15.109.0.2"

publish ATLA "15.0.0.0/8"

#WASH
echo "WASH"

creatGroup WASH "15.103.0.2"
setLocalPeer WASH "15.101.0.2"
setLocalPeer WASH "15.102.0.2"
setLocalPeer WASH "15.104.0.2"
setLocalPeer WASH "15.105.0.2"
setLocalPeer WASH "15.106.0.2"
setLocalPeer WASH "15.107.0.2"
setLocalPeer WASH "15.108.0.2"
setLocalPeer WASH "15.109.0.2"

publish WASH "15.0.0.0/8"

#NEWY
echo "NEWY"

creatGroup NEWY "15.101.0.2"
setLocalPeer NEWY "15.102.0.2"
setLocalPeer NEWY "15.103.0.2"
setLocalPeer NEWY "15.104.0.2"
setLocalPeer NEWY "15.105.0.2"
setLocalPeer NEWY "15.106.0.2"
setLocalPeer NEWY "15.107.0.2"
setLocalPeer NEWY "15.108.0.2"
setLocalPeer NEWY "15.109.0.2"

publish NEWY "15.0.0.0/8"

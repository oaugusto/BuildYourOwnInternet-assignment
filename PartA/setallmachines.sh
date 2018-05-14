#! /bin/bash

# set interface ip
setIP() {
    echo "vtysh \
        -c \"conf t\" \
        -c \"interface $2\" \
    	-c \"ip address $3\"" | ./bash-in.sh $1
}

# set OSPF
setOSPF() {
    echo "vtysh \
        -c \"conf t\" \
        -c \"router ospf\" \
        -c \"network $2 area 0\"" | ./bash-in.sh $1
}

# set interface cost
setCost() {
    echo "vtysh \
        -c \"conf t\" \
        -c \"interface $2\" \
        -c \"ip ospf cost $3\"" | ./bash-in.sh $1
}

# set HOST
setHost() {
    echo "ifconfig $2 $3" | ./bash-in.sh $1
    echo "route add default gw $4" | ./bash-in.sh $1 
}

#SEAT
echo "SEAT"
setHost SEAT-host seat "15.109.0.1/24" "15.109.0.2"

setIP SEAT host "15.109.0.2/24"
setIP SEAT losa "15.0.13.2/24"
setIP SEAT salt "15.0.12.2/24"

setOSPF SEAT "15.109.0.0/24"
setOSPF SEAT "15.0.13.0/24"
setOSPF SEAT "15.0.12.0/24"

setCost SEAT losa 1342
setCost SEAT salt 913

#LOSA
echo "LOSA"
setHost LOSA-host losa "15.108.0.1/24" "15.108.0.2"

setIP LOSA host "15.108.0.2/24"
setIP LOSA seat "15.0.13.1/24"
setIP LOSA salt "15.0.11.2/24"
setIP LOSA hous "15.0.10.2/24"

setOSPF LOSA "15.108.0.0/24"
setOSPF LOSA "15.0.13.0/24"
setOSPF LOSA "15.0.11.0/24"
setOSPF LOSA "15.0.10.0/24"

setCost LOSA seat 1342
setCost LOSA salt 1303
setCost LOSA hous 1705

#SALT
echo "SALT"
setHost SALT-host salt "15.107.0.1/24" "15.107.0.2"

setIP SALT host "15.107.0.2/24"
setIP SALT seat "15.0.12.1/24"
setIP SALT losa "15.0.11.1/24"
setIP SALT kans "15.0.9.2/24"

setOSPF SALT "15.107.0.0/24"
setOSPF SALT "15.0.12.0/24"
setOSPF SALT "15.0.11.0/24"
setOSPF SALT "15.0.9.0/24"

setCost SALT seat 913
setCost SALT losa 1303
setCost SALT kans 1330

#KANS
echo "KANS"
setHost KANS-host kans "15.105.0.1/24" "15.105.0.2"

setIP KANS host "15.105.0.2/24"
setIP KANS salt "15.0.9.1/24"
setIP KANS hous "15.0.8.1/24"
setIP KANS chic "15.0.6.2/24"

setOSPF KANS "15.105.0.0/24"
setOSPF KANS "15.0.9.0/24"
setOSPF KANS "15.0.8.0/24"
setOSPF KANS "15.0.6.0/24"

setCost KANS salt 1330
setCost KANS hous 818
setCost KANS chic 690

#HOUS
echo "HOUS"
setHost HOUS-host hous "15.106.0.1/24" "15.106.0.2"

setIP HOUS host "15.106.0.2/24"
setIP HOUS losa "15.0.10.1/24"
setIP HOUS kans "15.0.8.2/24"
setIP HOUS atla "15.0.7.2/24"

setOSPF HOUS "15.106.0.0/24"
setOSPF HOUS "15.0.10.0/24"
setOSPF HOUS "15.0.8.0/24"
setOSPF HOUS "15.0.7.0/24"

setCost HOUS losa 1705
setCost HOUS kans 818
setCost HOUS atla 1385

#CHIC
echo "CHIC"
setHost CHIC-host chic "15.102.0.1/24" "15.102.0.2"

setIP CHIC host "15.102.0.2/24"
setIP CHIC kans "15.0.6.1/24"
setIP CHIC atla "15.0.3.2/24"
setIP CHIC wash "15.0.2.2/24"
setIP CHIC newy "15.0.1.2/24"

setOSPF CHIC "15.102.0.0/24"
setOSPF CHIC "15.0.6.0/24"
setOSPF CHIC "15.0.3.0/24"
setOSPF CHIC "15.0.2.0/24"
setOSPF CHIC "15.0.1.0/24"

setCost CHIC kans 690
setCost CHIC atla 1045
setCost CHIC wash 905
setCost CHIC newy 1000

#ATLA
echo "ATLA"
setHost ATLA-host atla "15.104.0.1/24" "15.104.0.2"

setIP ATLA host "15.104.0.2/24"
setIP ATLA hous "15.0.7.1/24"
setIP ATLA chic "15.0.3.1/24"
setIP ATLA wash "15.0.5.2/24"

setOSPF ATLA "15.104.0.0/24"
setOSPF ATLA "15.0.7.0/24"
setOSPF ATLA "15.0.3.0/24"
setOSPF ATLA "15.0.5.0/24"

setCost ATLA hous 1385
setCost ATLA chic 1045
setCost ATLA wash 700

#WASH
echo "WASH"
setHost WASH-host wash "15.103.0.1/24" "15.103.0.2"

setIP WASH host "15.103.0.2/24"
setIP WASH atla "15.0.5.1/24"
setIP WASH chic "15.0.2.1/24"
setIP WASH newy "15.0.4.2/24"

setOSPF WASH "15.103.0.0/24"
setOSPF WASH "15.0.5.0/24"
setOSPF WASH "15.0.2.0/24"
setOSPF WASH "15.0.4.0/24"

setCost WASH atla 700
setCost WASH chic 905
setCost WASH newy 277

#NEWY
echo "NEWY"
setHost NEWY-host newy "15.101.0.1/24" "15.101.0.2"

setIP NEWY host "15.101.0.2/24"
setIP NEWY chic "15.0.1.1/24"
setIP NEWY wash "15.0.4.1/24"

setOSPF NEWY "15.101.0.0/24"
setOSPF NEWY "15.0.1.0/24"
setOSPF NEWY "15.0.4.0/24"

setCost NEWY chic 1000
setCost NEWY wash 277

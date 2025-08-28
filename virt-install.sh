# This script is a personal automation tool for deploying VMs using libvirt/KVM.
# It is not affiliated with any company or internal infrastructure.
# All bridge/VLAN/interface naming is generic and example-based.


#!/bin/bash
set -euo pipefail

echo -e "\e[33m###Welcome to the custom KVM VM installer script!###\e[0m"
sleep 2
now=$(date)
echo -e "\e[33m$now\e[0m "
sleep 2
good_dir="/var/lib/libvirt/images"

#Current directory verification
current_dir=$(pwd)

echo -e "Current directory is: \e[36m$current_dir.\e[0m \nPlease verify if you are in \e[36m$good_dir\e[0m!"
sleep 2

if [ "$current_dir" = "$good_dir" ]; then
        echo -e "You are in the right directory. The script will continue!"
else
        echo -e "Please put the script in \e[36m$good_dir\e[0m and try again. The script will now exit! "
        exit 1
fi

#Naming the VM
echo -e "Please provide the name of the VM:"
read name

while true; do
    echo -e "Is \e[36m$name\e[0m right? (y/n): "
    read -e resp
    if [ "$resp" = "y" ]; then
        echo -e "The VM name is \e[36m$name\e[0m."
        break
    elif [ "$resp" = "n" ]; then
        echo -e "Please re-enter the name:"
        read name
    else
        echo -e "Please use y or n only."
    fi
done

sleep 1

#Verification if the folder with the same name exists
qcow_dir=$good_dir/$name

if test -d "$qcow_dir"; then
	echo -e "The \e[36m$qcow_dir\e[0m exists and the installation can continue!"
else
	mkdir $name
	echo -e "The \e[36m$name\e[0m directory created!"
fi 

sleep 1

#Location for the QCOW verification

sleep 1
echo -e "The VM name will be: \e[36m$name\e[0m. \nThe folder for the VM will also have the same name. \n\e[31m###Warning!###\n Please rename the QCOW2 image with the exact same name as the VM and copy it to the new folder created! \e[0m"
sleep 5
file=$good_dir/$name/$name.qcow2
qcow_dir=$good_dir/$name

if test -f "$file"; then
	echo -e "\e[36m$file\e[0m exists and the installation can start!\n"
else
	echo -e "Please put the \e[36mQCOW2 in $qcow_dir.\e[0m \n The script will now exit!"
	sleep 3
	exit 1
fi 

sleep 3

#VLAN ID and network naming
ip addr
sleep 2
echo -e "Please provide the management \e[36mVLAN ID\e[0m: "
read vlan

while true; do
    echo -e "Is \e[36m$vlan\e[0m right? (y/n): "
    read -e resp
    if [ "$resp" = "y" ]; then
        echo -e "The VLAN ID is \e[36m$vlan\e[0m."
        break
    elif [ "$resp" = "n" ]; then
        echo -e "Please re-enter the name:"
        read vlan
    else
        echo -e "Please use y or n only."
    fi
done

sleep 1

#Management VLAN IP

echo -e "Please provide the \e[36mmanagement IP with subnet\e[0m:"
read ip_mainbr

while true; do
    echo -e "Is \e[36m$ip_mainbr\e[0m right? (y/n): "
    read -e resp
    if [ "$resp" = "y" ]; then
        echo -e "The management IP is \e[36m$ip_mainbr\e[0m."
        break
    elif [ "$resp" = "n" ]; then
        echo -e "Please re-enter the management IP:"
        read ip_mainbr
    else
        echo -e "Please use y or n only."
    fi
done 

sleep 1

#Management VLAN Default GW

echo -e "Please provide the \e[36mmanagement default GW\e[0m:"
read mainbr_gw

while true; do
    echo -e "Is \e[36m$mainbr_gw\e[0m right? (y/n): "
    read -e resp
    if [ "$resp" = "y" ]; then
        echo -e "The management gw IP is \e[36m$mainbr_gw\e[0m."
        break
    elif [ "$resp" = "n" ]; then
        echo -e "Please re-enter the management gateway:"
        read mainbr_gw
    else
        echo -e "Please use y or n only."
    fi
done 

sleep 1

# Ask how many NICs the VM needs
read -p "How many secbr interfaces do you want for this VM? " nic_count

while true; do
    echo -e "Is the number of secondary interfaces \e[36m$nic_count\e[0m right? (y/n): "
    read -e resp
    if [ "$resp" = "y" ]; then
        echo -e "The number of secondary interfaces: \e[36m$nic_count\e[0m."
        break
    elif [ "$resp" = "n" ]; then
        echo -e "Please re-enter the number of secondary interfaces you will use:"
        read vlan
    else
        echo -e "Please use y or n only."
    fi
done

net_args=""
net_sh=()
secbr_sh=()

for ((i=1; i<=nic_count; i++)); do
    echo -e "Enter VLAN ID for secbr \e[36m$i\e[0m: "
	read secbr_id
	while true; do
    echo -e "Is \e[36m$secbr_id\e[0m right? (y/n): "
    read -e resp
    if [ "$resp" = "y" ]; then
        echo -e "The secbr ID is \e[36m$secbr_id\e[0m."
		net_args+=" --network bridge=br-net-$secbr_id,model=virtio"
		net_sh+=($secbr_id)
		echo -e "Please provide the \e[36msecbr$i IP with subnet\e[0m:"
		read secbr_ip

			while true; do
				echo -e "Is \e[36m$secbr_ip\e[0m right? (y/n): "
				read -e resp
				if [ "$resp" = "y" ]; then
					echo -e "The secbr\e[36m$i\e[0m IP is \e[36m$secbr_ip\e[0m."
					secbr_sh+=($secbr_ip)
					break
				elif [ "$resp" = "n" ]; then
					echo -e "Please re-enter the secbr$i IP:"
					read secbr_ip
				else
					echo -e "Please use y or n only."
				fi
			done 
        break
    elif [ "$resp" = "n" ]; then
        echo -e "Please re-enter the name:"
        read secbr_id
    else
        echo -e "Please use y or n only."
    fi
done
    
done

#Create network script

echo "${net_sh[@]}"
echo "${secbr_sh[@]}"

cat << EOF > interfaces

# This file describes the network interfaces available on your system
# and how to activate them. For more information, see interfaces(5).

source /etc/network/interfaces.d/*
# The loopback netw interfaces
auto lo
iface lo inet loopback
   dns-nameservers 1.1.1.1, 2.2.2.2, 3.3.3.3

# bond-main-$vlan
auto eth0
iface eth0 inet static
   address $ip_mainbr
   post-up route add default gw $mainbr_gw || true
   post-down route del default gw $mainbr_gw || true
     
EOF

cat interfaces

for ((i=0; i<nic_count; i++)); do

iface="eth$((i+1))"

cat << EOF >> interfaces

# bond-sec-${net_sh[$i]}
auto $iface
iface $iface inet static
   address ${secbr_sh[$i]}

EOF

done

cat interfaces

sleep 2

#Verification if the VM exists

if virsh list --all --name | grep -wq "$name"; then
    echo -e "A VM named \e[33m$name\e[0m already exists. Aborting."
	sleep 2
    exit 1
else
	echo -e "There is no VM named \e[33m$name\e[0m."
	sleep 2
	
fi

echo -e "\e[33m###The instalation will now start!###\e[0m"

sleep 1

for i in {5..1}; do
    echo -ne "\nCountdown: $i "
    sleep 1
done

sleep 1



#Inject the network script into the image

virt-customize -a $file \
--copy-in ./interfaces:/etc/network \

sleep 1

#Start of the VM installation
# You can manually modify the vCPU and RAM in the following lines.

sudo virt-install \
--name $name \
--os-variant debian12 \
--vcpu 4 \
--ram 8192 \
--network bridge:br-net-$vlan \
$net_args \
--graphics vnc \
--import \
--disk path=$file,size=150,format=qcow2,bus=virtio \
--noautoconsole

echo -e "\e[33m###The $name VM was installed###\e[0m"
sleep 1
virsh list
sleep 1

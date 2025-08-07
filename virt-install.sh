#!/bin/bash

echo -e "\e[33m###Welcome to the installation  script for SBTS Image for KVM!###\e[0m"
sleep 2
now=$(date)
echo -e "\e[33m$now\e[0m "
sleep 2
good_dir="/var/lib/libvirt/images"

#Current directory verification
current_dir=$(pwd)

echo -e "Current directory is: \e[34m$current_dir.\e[0m \nPlease verify if you are in \e[34m$good_dir\e[0m!"
sleep 2

if [ "$current_dir" = "$good_dir" ]; then
        echo -e "You are in the right directory. The script will continue!"
else
        echo -e "Please put the script in \e[34m$good_dir\e[0m and try again. The script will now exit! "
        exit 1
fi

#Naming the VM
echo -e "Please provide the name of the VM:"
read name

while true; do
    echo -e "Is \e[34m$name\e[0m right? (y/n): "
    read -e resp
    if [ "$resp" = "y" ]; then
        echo -e "The VM name is \e[34m$name\e[0m."
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
	echo -e "The \e[34m$qcow_dir\e[0m exists and the installation can continue!"
else
	mkdir $name
	echo -e "The \e[34m$name\e[0m directory created!"
fi 

sleep 1

#Location for the QCOW verification

sleep 1
echo -e "The VM name will be: \e[34m$name\e[0m. \nThe folder for the VM will also have the same name. \n\e[31m###Warning!###\n Please rename the QCOW2 image with the exact same name as the VM and copy it to the new folder created! \e[0m"
sleep 5
file=$good_dir/$name/$name.qcow2
qcow_dir=$good_dir/$name

if test -f "$file"; then
	echo -e "\e[34m$file\e[0m exists and the installation can start!\n"
else
	echo -e "Please put the \e[34mQCOW2 in $qcow_dir.\e[0m \n The script will now exit!"
	sleep 3
	exit 1
fi 

sleep 3

#VLAN ID and network naming
ip addr
sleep 2
echo -e "Please provide the management \e[34mVLAN ID\e[0m: "
read vlan

while true; do
    echo -e "Is \e[34m$vlan\e[0m right? (y/n): "
    read -e resp
    if [ "$resp" = "y" ]; then
        echo -e "The VLAN ID is \e[34m$vlan\e[0m."
        break
    elif [ "$resp" = "n" ]; then
        echo -e "Please re-enter the name:"
        read vlan
    else
        echo -e "Please use y or n only."
    fi
done
sleep 2

# Ask how many NICs the VM needs
read -p "How many LMP interfaces do you want for this VM? " nic_count
net_args=""
net_sh=()

for ((i=1; i<=nic_count; i++)); do
    echo -e "Enter VLAN ID for LMP \e[34m$i\e[0m: "
	read lmp_id
	while true; do
    		echo -e "Is \e[34m$lmp_id\e[0m right? (y/n): "
    		read -e resp
    	if [ "$resp" = "y" ]; then
        	echo -e "The LMP ID is \e[34m$lmp_id\e[0m."
			net_args+=" --network bridge=bondL-lmp-$lmp_id,model=virtio"
   			net_sh+=($lmp_id)
        		break
    	elif [ "$resp" = "n" ]; then
        	echo -e "Please re-enter the name:"
        	read lmp_id
    	else
        	echo -e "Please use y or n only."
    	fi
	done
    
done

sleep 2

#Create network script

echo "${net_sh[@]}"

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

for i in {5..1}; do
    echo -ne "\nCountdown: $i "
    sleep 1
done

#Inject the network script into the image

virt-customize -a $file \
--copy-in ./network-script.sh:/home/user \
--run-command "chmod +x /home/user/network-script.sh"

sleep 1

sudo virt-install \
--name $name \
--os-variant debian12 \
--vcpu 4 \
--ram 8192 \
--network bridge:bondM-mng-$vlan \
$net_args \
--graphics vnc \
--import \
--disk path=$file,size=150,format=qcow2,bus=virtio \
--noautoconsole

echo -e "\e[33m###The $name VM was installed###\e[0m"
sleep 1
virsh list
sleep 1

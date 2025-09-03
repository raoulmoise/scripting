#!/bin/bash

echo -e "\e[33m###Welcome to the generation script for bridge network in KVM!###\e[0m"
now=$(date)
echo -e "\e[33m$now\e[0m "

good_dir="/etc/sysconfig/network-scripts"

#Current directory verification
current_dir=$(pwd)

echo -e "Current directory is: \e[36m$current_dir.\e[0m \nPlease verify if you are in \e[36m$good_dir\e[0m!"

if [ "$current_dir" = "$good_dir" ]; then
        echo -e "You are in the right directory. The script will continue!"
else
        echo -e "Please put the script in \e[36m$good_dir\e[0m and try again. The script will now exit! "
        exit 1
fi

: '#User input for network VLAN interface

echo -e "Please provide the name of the VLAN interface:"
read vlan

while true; do
    echo -e "Is \e[36m$vlan\e[0m right? (y/n): "
    read -e resp
    if [ "$resp" = "y" ]; then
        echo -e "The network VLAN interface is \e[36m$vlan\e[0m."
        break
    elif [ "$resp" = "n" ]; then
        echo -e "Please re-enter the name of the VLAN interface:"
        read name
    else
        echo -e "Please use y or n only."
    fi
done

'

# Ask how many bond files you need to create?
read -p "How many LMP interfaces do you want for this VM? " bond_count
bond_files=()

for ((i=1; i<=bond_count; i++)); do
    echo -e "Enter VLAN ID \e[36m$i\e[0m: "
	read vlan_id
	while true; do
    echo -e "Is \e[36m$vlan_id\e[0m right? (y/n): "
    read -e resp
    if [ "$resp" = "y" ]; then
        echo -e "The LMP ID is \e[36m$vlan_id\e[0m."
		bond_files+=($vlan_id)
		break
    elif [ "$resp" = "n" ]; then
        echo -e "Please re-enter the name:"
        read vlan_id
    else
        echo -e "Please use y or n only."
    fi
done
done


#Generating the script files

for ((i=0; i<bond_count; i++)); do
#Bridge config
cat << EOF > ifcfg-bondL-lmp-${bond_files[$i]}
DEVICE=bondL-lmp-${bond_files[$i]}
TYPE=Bridge
BOOTPROTO=none
ONBOOT=yes
DELAY=0
NM_CONTROLLED=no
     
EOF

echo "Generated:ifcfg-bondL-lmp-${bond_files[$i]}"
cat ifcfg-bondL-lmp-${bond_files[$i]}

#Vlan-on-bond config
cat << EOF > ifcfg-bondL.${bond_files[$i]}
TYPE=Ethernet
BOOTPROTO=none
DEVICE=bondL.${bond_files[$i]}
ONBOOT=yes
VLAN=yes
BRIDGE=bondL-lmp-${bond_files[$i]}
     
EOF

echo "Generated:ifcfg-bondL.${bond_files[$i]}"
cat ifcfg-bondL.${bond_files[$i]}


done

echo -e "\e[32mDone. Review files, then apply changes (e.g., 'systemctl restart network').\e[0m"

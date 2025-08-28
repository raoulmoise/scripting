#!/bin/bash
set -euo pipefail

echo -e "\e[33m###Welcome to the generation script for bridge network Scripts in KVM!###\e[0m"
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

#User input for network interface

echo -e "Please provide the name of the interface:"
read int

while true; do
    echo -e "Is \e[36m$int\e[0m right? (y/n): "
    read -e resp
    if [ "$resp" = "y" ]; then
        echo -e "The network interface is \e[36m$int\e[0m."
        break
    elif [ "$resp" = "n" ]; then
        echo -e "Please re-enter the name of the interface:"
        read name
    else
        echo -e "Please use y or n only."
    fi
done


#Generating the script files

#Bridge config
cat << EOF > ifcfg-bridge-$int
DEVICE=bridge-$int
TYPE=Bridge
BOOTPROTO=none
ONBOOT=yes
DELAY=0
NM_CONTROLLED=no
     
EOF
echo "Generated: ifcfg-bridge-$int"
cat ifcfg-bridge-$int

#Vlan-on-bond config
cat << EOF > ifcfg-bond.$int
TYPE=Ethernet
BOOTPROTO=none
DEVICE=bond.$int
ONBOOT=yes
VLAN=yes
BRIDGE=bridge-$int
     
EOF
echo "Generated: ifcfg-bond.$int"
cat ifcfg-bond.$int

echo -e "\e[32mDone. Review files, then apply changes (e.g., 'systemctl restart network').\e[0m"

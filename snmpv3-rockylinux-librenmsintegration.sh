# This script is a personal automation tool for deploying VMs using libvirt/KVM/RockyLinux.
# It is not affiliated with any company or internal infrastructure.

#! /bin/bash
set -euo pipefail

#SNMPv3 configuration script for LibreNMS integration

echo -e "\e[33m###Welcome to the configuration  script for SNMPv3 for Rocky Linux for LibreNMS integration!###\e[0m"
sleep 2
now=$(date)
echo -e "\e[33m$now\e[0m "
sleep 2

#Install the mandatory packages for SNMP
echo -e "\e[33m###SNMP packages will now begin to install, please have the proxy configured to allow!###\e[0m"

for i in {3..1}; do
    echo -ne "\nCountdown: $i "
    sleep 1
done

sudo dnf install net-snmp net-snmp-utils

wait 

cp /etc/snmp/snmpd.conf /etc/snmp/snmpd.conf.bak

#Copy the community to the configuration file
sed -i '/^rocommunity/ s/^/#/' /etc/snmp/snmpd.conf

sleep 2

systemctl stop snmpd

sleep 2

#SNMPv3 - User Configuration

#Auth User Name
echo -e "Please provide the \e[36mSNMP user\e[0m:"
read snmpUser

while true; do
    echo -e "Is \e[36m$snmpUser\e[0m right? (y/n): "
    read -e resp
    if [ "$resp" = "y" ]; then
        echo -e "The SNMP user is \e[36m$snmpUser\e[0m."
        break
    elif [ "$resp" = "n" ]; then
        echo -e "Please re-enter the SNMP user:"
        read snmpUser
    else
        echo -e "Please use y or n only."
    fi
done 

sleep 1 

#Auth Password
echo -e "Please provide the \e[36mAuthentication Password\e[0m:"
read auth_pass

while true; do
    echo -e "Is \e[36m$auth_pass\e[0m right? (y/n): "
    read -e resp
    if [ "$resp" = "y" ]; then
        echo -e "The Authentication Password is \e[36m$auth_pass\e[0m."
        break
    elif [ "$resp" = "n" ]; then
        echo -e "Please re-enter the Authentication Password:"
        read auth_pass
    else
        echo -e "Please use y or n only."
    fi
done 

sleep 1

#Auth Algortihm
while true; do
    echo -e "Please select one of the following Authentication Algorithms: \e[36m\n1. SHA\n2. SHA-224\n3. SHA-256\n4. SHA-384\n5. SHA-512\e[0m"
    read -p "Your choice (1–5): " choice

    case "$choice" in
        1) auth_alg="SHA" ;;
        2) auth_alg="SHA-224" ;;
        3) auth_alg="SHA-256" ;;
        4) auth_alg="SHA-384" ;;
        5) auth_alg="SHA-512" ;;
        *) echo "Invalid choice. Please choose 1–5."; continue ;;
    esac

    while true; do
        echo -e "Is \e[36m$auth_alg\e[0m right? (y/n): "
        read -e resp
        if [ "$resp" = "y" ]; then
            echo -e "The Authentication Algorithm is \e[36m$auth_alg\e[0m."
            break 2  
        elif [ "$resp" = "n" ]; then
            echo -e "Let's reselect the Authentication Algorithm."
            break    
        else
            echo -e "Please use y or n only."
        fi
    done
done


sleep 1

#Crypto Password
echo -e "Please provide the \e[36m$Crypto Password\e[0m:"
read cry_pass

while true; do
    echo -e "Is \e[36m$cry_pass\e[0m right? (y/n): "
    read -e resp
    if [ "$resp" = "y" ]; then
        echo -e "The Crypto Password is \e[36m$cry_pass\e[0m."
        break
    elif [ "$resp" = "n" ]; then
        echo -e "Please re-enter the Crypto Password:"
        read cry_pass
    else
        echo -e "Please use y or n only."
    fi
done

sleep 1

# Crypto Algorithm Selection
while true; do
    echo -e "Please select one of the following Crypto Algorithms: \e[36m\n1. AES\n2. AES-192\n3. AES-256\n4. AES-256-C\n5. DES\e[0m"
    read -p "Your choice (1–5): " choice

    case "$choice" in
        1) cry_alg="AES" ;;
        2) cry_alg="AES-192" ;;
        3) cry_alg="AES-256" ;;
        4) cry_alg="AES-256-C" ;;
        5) cry_alg="DES" ;;
        *) echo "Invalid choice. Please choose 1–5."; continue ;;
    esac

    while true; do
        echo -e "Is \e[36m$cry_alg\e[0m right? (y/n): "
        read -e resp
        if [ "$resp" = "y" ]; then
            echo -e "The Crypto Algorithm is \e[36m$cry_alg\e[0m."
            break 2  
        elif [ "$resp" = "n" ]; then
            echo -e "Let's reselect the Crypto Algorithm."
            break     
        else
            echo -e "Please use y or n only."
        fi
    done
done

sleep 1

net-snmp-create-v3-user -ro -A $auth_pass -a $auth_alg -X $cry_pass -x $cry_alg $snmpUser

sleep 2

systemctl start snmpd
wait 

sleep 2

systemctl enable snmpd
wait

sleep 2

#Firewall port add
firewall-cmd --add-port=161/udp --permanent
firewall-cmd --reload

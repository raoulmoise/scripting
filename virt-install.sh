#!/bin/bash

echo "Please provide the name of the VM:"
read name

while true; do
    read -p "Is \"$name\" right? (y/n): " resp
    if [ "$resp" = "y" ]; then
        echo "The VM name is $name."
        break
    elif [ "$resp" = "n" ]; then
        echo "Please re-enter the name:"
        read name
    else
        echo "Please use y or n only."
    fi
done

echo "$name"
ip addr
read -p "Please provide the management VLAN ID: "  vlan
echo "VLAN $vlan"

sudo virt-install \
--name $name \
--os-variant debian12 \
--vcpu 4 \
--ram 8192 \
--network bridge:<NETWORK BRIDGE> \
--graphics vnc \
--import \
--disk path=/path/to/folder/VM-Image.qcow2,size=150,format=qcow2,bus=virtio \
--noautoconsole


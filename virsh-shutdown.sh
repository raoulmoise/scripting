#!/bin/bash

virsh list --name > virshname.txt
 sleep 3
 virsh list
 echo "=== Using this script will turn off all KVM VMs ==="
sleep 3
 for i in $(virsh list | grep running | awk '{print $2}')
 do
 virsh shutdown $i
 sleep 5

done

 virsh list


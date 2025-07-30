#!/bin/bash

sudo virt-install \
--name <NAME> \
--os-variant debian12 \
--vcpu 4 \
--ram 8192 \
--network bridge:<NETWORK BRIDGE> \
--graphics vnc \
--import \
--disk path=/path/to/folder/VM-Image.qcow2,size=150,format=qcow2,bus=virtio \
--noautoconsole


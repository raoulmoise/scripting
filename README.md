# 📜 Scripting

This repository contains various scripts I have created to assist with my homelab and day-to-day work projects.

---

# 📂 Repo Structure
## - [kvm-virt-install](https://github.com/raoulmoise/scripting/blob/main/kvm-virt-install/virt-install.sh)
### 🗃️ KVM VM Installer Script

This script automates the creation and network configuration of virtual machines using `virt-install` and `virt-customize`.

---

## - [kvm-virsh-shutdown](https://github.com/raoulmoise/scripting/blob/main/kvm-virsh-shutdown/virsh-shutdown.sh)
### 🗃️ KVM Mass Shutdown Script

This Bash script automates shutting down all running KVM virtual machines managed by `virsh`.

---

## - [snmpv3-rocky-librenms](https://github.com/raoulmoise/scripting/blob/main/snmpv3-rocky/snmpv3-rockylinux-librenmsintegration.sh)
## 🗃️ Rocky Linux SNMPv3 configuration for LibreNMS integration 

This Bash script automates the configuration of the SNMPv3 settings on a Rocki Linux device for LibreNMS integration.

---

## - [network-bond-file](https://github.com/raoulmoise/scripting/blob/main/network-bond-file/network-bond-file.sh)
### 🛠️ Bridge + VLAN Config Generator (KVM - Rocky Linux)

This Bash script generates legacy `network-scripts` files to create a **bridge** on top of a **VLAN-on-bond** interface (e.g., `bridge-100` over `bond0.100`) for KVM hosts.

---


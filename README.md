# 📜 Scripting

This repository contains various scripts I have created to assist with my homelab and day-to-day work projects.

---

# 📂 Repo Structure

# scripting/
# - [kvm-virt-install](https://github.com/raoulmoise/scripting/blob/main/kvm-virt-install/virt-install.sh)

## 🗃️ KVM VM Installer Script

This script automates the creation and network configuration of virtual machines using `virt-install` and `virt-customize`.

### 🧠 Features
- Prompts for VM name, QCOW2 image, VLANs, and IPs
- Injects network config directly into the image
- Supports multiple NICs/bridges
- Simple validation and countdown for safety

### Disclaimer
This is a personal project and is not affiliated with any company or internal infrastructure. All bridge/interface naming is generic and used for demonstration purposes.

### 🚧 Requirements
- `virt-install`, `virt-customize`, `libvirt`, `KVM`

### ▶️ Usage
1. Copy the script to the target host and make it executable:
   ```bash
   chmod +x kvm-virt-install.sh

---

# - [kvm-virsh-shutdown](https://github.com/raoulmoise/scripting/blob/main/kvm-virsh-shutdown/virsh-shutdown.sh)
## 🗃️ KVM Mass Shutdown Script

This Bash script automates shutting down all running KVM virtual machines managed by `virsh`.

### 🧠 Features
- Lists all defined VMs and saves their names to `virshname.txt`.
- Displays the currently running VMs before shutdown.
- Iterates over all running VMs and gracefully shuts them down with `virsh shutdown`.
- Adds a small delay between shutdown commands to avoid conflicts.
- Shows the updated VM status after execution.

### 🚧 Requirements
- `virt-install`, `virt-customize`, `libvirt`, `KVM`

### ▶️ Usage
1. Copy the script to the target host and make it executable:
   ```bash
   chmod +x kvm-virsh-shutdown.sh

---

# - [snmpv3-rocky-librenms](https://github.com/raoulmoise/scripting/blob/main/snmpv3-rocky/snmpv3-rockylinux-librenmsintegration.sh)
## 🗃️ Rocky Linux SNMPv3 configuration for LibreNMS integration 

This Bash script automates the configuration of the SNMPv3 settings on a Rocki Linux device for LibreNMS integration.

### 🧠 Features
- Prompts for SNMP User, Password, and Authentication methods.
- Install the dependencies and SNMP packages for Rocky Linux.
- Configure the SNMP file with the user input variables.
- Add the UDP 161 to the internal firewall

### 🚧 Requirements
- Rocky Linux 8.x, 9.x, 10.x
- Run as root or with sudo


### ▶️ Usage
1. Copy the script to the target host and make it executable:
   ```bash
   chmod +x snmpv3-rocky-librnms.sh

---

# - [network-bond-file](https://github.com/raoulmoise/scripting/blob/main/network-bond-file/network-bond-file.sh)
## 🛠️ Bridge + VLAN Config Generator (KVM - Rocky Linux)

This Bash script generates legacy `network-scripts` files to create a **bridge** on top of a **VLAN-on-bond** interface (e.g., `bridge-100` over `bond0.100`) for KVM hosts.

---

### 🧠 Features
- Verifies you run it from `/etc/sysconfig/network-scripts`.
- Prompts for **VLAN ID** and **bond interface** (default `bond0`).
- Generates:
  - `ifcfg-bridge-<VLAN>` (Bridge)
  - `ifcfg-<BOND>.<VLAN>` (VLAN-on-bond)
- Sets sane defaults: `ONBOOT=yes`, `BOOTPROTO=none`, `NM_CONTROLLED=no`.
- Prints the generated files so you can review before applying.

---

### 🚧 Requirements
- Rocky Linux using legacy **network-scripts**.
- Root privileges to place files in `/etc/sysconfig/network-scripts`.
- KVM/libvirt host (for the bridge to be used by `virsh`/`libvirt` networks).
- Tools: standard GNU userland (`bash`, `cat`, etc.).

### ▶️ Usage
1. Copy the script to the target host and make it executable:
   ```bash
   chmod +x network-bond-file.sh

---

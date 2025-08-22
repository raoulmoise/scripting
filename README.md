# 📜 Scripting

This repository contains various scripts I have created to assist with my homelab and day-to-day work projects.

---

# 📂 Repo Structure

# scripting/
# - [kvm-virt-install](https://github.com/raoulmoise/scripting/blob/main/virt-install.sh)

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

---

# - [kvm-virsh-shutdown](https://github.com/raoulmoise/scripting/blob/main/virsh-shutdown.sh)

## 🗃️ KVM Mass Shutdown Script

This Bash script automates shutting down all running KVM virtual machines managed by `virsh`.

---

### 🧠 Features
- Lists all defined VMs and saves their names to `virshname.txt`.
- Displays the currently running VMs before shutdown.
- Provides a warning message before execution.
- Iterates over all running VMs and gracefully shuts them down with `virsh shutdown`.
- Adds a small delay between shutdown commands to avoid conflicts.
- Shows the updated VM status after execution.

### 🚧 Requirements
- `virt-install`, `virt-customize`, `libvirt`, `KVM`

---

## Debian SNMPv3 auto-configure | *(Coming soon)* |

---



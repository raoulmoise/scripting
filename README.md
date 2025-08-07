## 📜 Scripting

This repository contains various scripts I have created to assist with my homelab and day-to-day work projects.

---

## 📂 Repo Structure

scripting/
- [kvm-virt-install](virt-install.sh)

# KVM VM Installer Script

This script automates the creation and network configuration of virtual machines using `virt-install` and `virt-customize`.

## Features
- Prompts for VM name, QCOW2 image, VLANs, and IPs
- Injects network config directly into the image
- Supports multiple NICs/bridges
- Simple validation and countdown for safety

## Disclaimer
This is a personal project and is not affiliated with any company or internal infrastructure. All bridge/interface naming is generic and used for demonstration purposes.

## Requirements
- `virt-install`, `virt-customize`, `libvirt`, `KVM`

- [kvm-virsh-shutdown](virsh-shutdown.sh)

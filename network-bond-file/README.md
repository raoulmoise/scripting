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

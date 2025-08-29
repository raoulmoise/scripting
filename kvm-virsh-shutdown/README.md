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

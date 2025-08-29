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

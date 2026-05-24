# Linux Sandbox & Isolation Environment


A lightweight `bash` script designed to create a secure, isolated sandbox environment in Linux using native utilities like `unshare` and `chroot`. This tool provides a safe space for testing files or applications without risking the integrity or security of your host system.

## ✨ Features

*   🔒 **Filesystem Locking:** Restricts sandbox access entirely to the designated `$JAIL_DIR` using `chroot`.
*   🚫 **Network Isolation:** Completely unshares the network namespace, cutting off inbound and outbound traffic to prevent unauthorized data transmission.
*   🆔 **Process Isolation:** Spawns a dedicated Process ID (PID) namespace where the sandbox shell operates as PID 1, hiding host processes from view.
*   🧹 **Safe Cleanup:** Automatically terminates internal processes and cleans up safely upon exiting the environment.

---

## 🚀 Usage Guide

### 1. Prerequisites
Before running the script, ensure that your directory structure is prepared and contains the necessary base binaries (such as `/bin/bash` and its dependencies). 

By default, the script points to this directory:
```bash
# /var/sandbox/jail


# Grant execution permissions
# chmod +x sandbox.sh

# Run the script with sudo
# sudo ./sandbox.sh



## 🪟 Windows Server Sandbox & Isolation Environment

# A PowerShell-based automation script designed to spin up a secure, isolated Windows container environment using Docker and Windows Server Core. This replicates the isolation principles of the Linux `chroot`/`unshare` setup on a Windows host.

### ✨ Features

*   🔒 **Filesystem Locking:** Completely restricts operations to the isolated container layer; any changes are destroyed upon exit.
*   🚫 **Network Isolation:** Disables the network stack (`--network none`) to prevent lateral movement, data exfiltration, or inbound/outbound exploits.
*   🆔 **Process Isolation:** Runs inside a dedicated container namespace (Hyper-V or Process Isolation), completely hiding host processes and infrastructure.
*   🛡️ **Admin Enforcement:** Automatically checks for elevated privileges to ensure the environment initializes with proper kernel access control.

---

### 🚀 Usage Guide

#### 1. Prerequisites
Before running the script, ensure that the Windows Containers feature and Docker CE are installed on your Windows Server or Windows 10/11 Pro/Enterprise machine.

Run the following commands in an **Elevated PowerShell** prompt to set up the environment:

```powershell
# Step 1: Install the Windows Containers feature
Install-WindowsFeature -Name Containers

# Step 2: Restart your computer to apply changes
Restart-Computer

# Step 3: Download and run the Docker CE installation script for Windows
Invoke-WebRequest -UseBasicParsing "[https://raw.githubusercontent.com/microsoft/Windows-Containers/Main/helpful_tools/Install-DockerCE/install-docker-ce.ps1](https://raw.githubusercontent.com/microsoft/Windows-Containers/Main/helpful_tools/Install-DockerCE/install-docker-ce.ps1)" -o install-docker-ce.ps1
.\install-docker-ce.ps1

#[!WARNING]
#IMPORTANT SECURITY NOTICE: This script is intended purely for educational, development, and basic testing purposes. It does NOT provide production-grade security hardening.
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
/var/sandbox/jail


# Grant execution permissions
chmod +x sandbox.sh

# Run the script with sudo
sudo ./sandbox.sh


[!WARNING]
IMPORTANT SECURITY NOTICE: This script is intended purely for educational, development, and basic testing purposes. It does NOT provide production-grade security hardening.
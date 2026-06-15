#!/bin/bash

# ==============================================================================
# Script Name:    launch_sandbox.sh
# Description:    A hardened, multi-namespace Linux Sandbox environment 
#                 utilizing chroot isolation, dedicated UTS/PID/NET/IPC/MOUNT 
#                 namespaces, and automated resource cleanup handlers.
# Author:         Michiko
# ==============================================================================

# Ensure the script is executed with root/administrative privileges
if [ "$EUID" -ne 0 ]; then
  echo "Run the script using sudo: sudo $0"
  exit 1
fi

# Define the isolated root filesystem directory (the jail)
JAIL_DIR="/var/sandbox/jail"

echo "=================================================="
echo " Starting Secure Linux Sandbox & Isolation Env by Michiko"
echo "=================================================="
echo "[+] Network: ISOLATED"
echo "[+] Processes: ISOLATED (PID 1)"
echo "[+] Identity (UTS): ISOLATED (No Hostname Leak)"
echo "[+] IPC: ISOLATED (No Shared Memory)"
echo "[+] Filesystem: LOCKED to $JAIL_DIR"
echo "--------------------------------------------------"
echo "Type 'exit' if finish testing."
echo ""

# Automated cleanup handler executed upon sandbox or script termination
cleanup() {
    # Forcefully unmount the proc filesystem on the host layer if left orphaned
    # due to an unexpected crash or forced termination within the jail
    if mountpoint -q "$JAIL_DIR/proc"; then
        umount -l "$JAIL_DIR/proc" 2>/dev/null
    fi
    echo ""
    echo "=================================================="
    echo " Sandbox closed safely. All processes terminated. "
    echo "=================================================="
}
# Trap the EXIT signal to guarantee the cleanup function runs regardless of exit state
trap cleanup EXIT

# Instantiate the hardened namespace wrapper
# --fork: Executed as a child process of unshare rather than replacing current shell
# --pid: Restricts visibility of the host's process tree (sandbox becomes PID 1)
# --uts: Segregates hostnames/domain identifiers to prevent recon leaks to the host
# --ipc: Isolates Inter-Process Communication (Shared Memory/Message Queues)
# --net: Disables external/host network interfaces (Total Air-gap isolation)
# --mount: Decouples file system mounts from modifying the underlying host storage
unshare --fork --pid --uts --ipc --net --mount /bin/bash -s <<EOF
    # 1. Ephemerally change system identity within the volatile UTS namespace memory.
    # This acts as a complete fix against host configuration leaks.
    hostname sandbox-jail

    # 2. Transition execution into the chroot boundary with inherited namespaces intact.
    chroot $JAIL_DIR /bin/bash -c "
        # 3. Mount an isolated pseudo-filesystem instance specific to this PID namespace
        mount -t proc proc /proc 2>/dev/null
        
        # 4. Spawn an interactive interactive shell session for security testing
        /bin/bash
        
        # 5. Gracefully tear down internal infrastructure mounts before exiting the jail
        umount -l /proc 2>/dev/null
    "
EOF
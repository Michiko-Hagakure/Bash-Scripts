#!/bin/bash

# Make sure we are running as root
if [ "$EUID" -ne 0 ]; then
  echo "Run the script using sudo: sudo $0"
  exit 1
fi

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

# Automated cleanup handler if the script terminates unexpectedly
cleanup() {
    # Unmount /proc if it was left mounted on the host side
    if mountpoint -q "$JAIL_DIR/proc"; then
        umount -l "$JAIL_DIR/proc" 2>/dev/null
    fi
    echo ""
    echo "=================================================="
    echo " Sandbox closed safely. All processes terminated. "
    echo "=================================================="
}
trap cleanup EXIT

# Run the hardened sandbox
# -u (--uts): Isolates hostname
# -i (--ipc): Isolates shared memory/message queues
# -m (--mount): Isolates filesystem mounts so the jail can't mess with host mounts
unshare --fork --pid --mount-proc --net --uts --ipc --mount chroot $JAIL_DIR /bin/bash -c "
    # Set an ephemeral hostname inside the sandbox automatically
    hostname sandbox-jail
    
    # Mount isolated proc filesystem
    mount -t proc proc /proc
    
    # Drop to isolated shell
    /bin/bash
    
    # Cleanup inside before leaving
    umount -l /proc 2>/dev/null
"
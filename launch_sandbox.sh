#!/bin/bash

# make sure we are running as root
if [ "$EUID" -ne 0 ]; then
  echo "run a script using sudo : sudo $0"
  exit 1
fi

JAIL_DIR="/var/sandbox/jail"

echo "=================================================="
echo " Starting Secure Linux Sandbox & Isolation Env by Michiko"
echo "=================================================="
echo "[+] Network: ISOLATED"
echo "[+] Processes: ISOLATED (PID 1)"
echo "[+] Filesystem: LOCKED to $JAIL_DIR"
echo "--------------------------------------------------"
echo "Type 'exit' if finish testing."
echo ""

# run the sandbox
unshare --fork --pid --mount-proc --net chroot $JAIL_DIR /bin/bash -c "
    mount -t proc proc /proc
    /bin/bash
"

echo ""
echo "=================================================="
echo " Sandbox closed safely. All processes terminated. "
echo "=================================================="
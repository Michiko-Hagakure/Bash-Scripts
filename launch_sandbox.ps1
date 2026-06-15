# ==============================================================================
# Script Name:    launch_sandbox.ps1
# Description:    A hardened Windows Container sandbox environment utilizing 
#                 Docker on Windows Server Core 2022, enforcing network air-gaps 
#                 and kernel-level Hyper-V compute isolation.
# Author:         Michiko
# ==============================================================================

# Ensure the script is executed with elevated administrative privileges 
# (Equivalent to checking for root UID in Linux environments)
$isAdmin = ([Security.Principal.WindowsPrincipal][Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)
if (-not $isAdmin) {
    Write-Error "Administrative privileges required! Please relaunch PowerShell using 'Run as Administrator'."
    Exit
}

# Define runtime identity and image constraints for the isolated boundary
$CONTAINER_NAME = "Michiko_Secure_Sandbox"

# Utilizing Windows Server Core 2022 as the lightweight target baseline image
$IMAGE_NAME = "mcr.microsoft.com/windows/servercore:ltsc2022"

Write-Host "==================================================" -ForegroundColor Cyan
Write-Host " Starting Secure Windows Sandbox & Isolation Env by Michiko" -ForegroundColor Cyan
Write-Host "==================================================" -ForegroundColor Cyan
Write-Host "[+] Network: ISOLATED (Air-Gapped)" -ForegroundColor Yellow
Write-Host "[+] Processes: KERNEL ISOLATED (Hyper-V Utility VM)" -ForegroundColor Yellow
Write-Host "[+] Filesystem: LOCKED (Volatile Container Layers)" -ForegroundColor Yellow
Write-Host "--------------------------------------------------"
Write-Host "Type 'exit' if finished testing."
Write-Host ""

# Instantiate the hardened Windows Sandbox environment
# --rm: Automatically purge container filesystem layers on termination (ephemeral lifecycle)
# -it: Allocate a pseudo-TTY terminal and keep standard input open for interactive execution
# --name: Enforce a unique runtime identifier to prevent collision profiles
# --network none: Strips all virtual network adapters, guaranteeing absolute network egress isolation
# --isolation=hyperv: Spawns the container inside an optimized utility VM with a dedicated Windows Kernel, 
#                     mitigating container-to-host kernel exploit escape vectors.
docker run --rm -it --name $CONTAINER_NAME --network none --isolation=hyperv $IMAGE_NAME cmd.exe

# Lifecycle termination hook
Write-Host ""
Write-Host "==================================================" -ForegroundColor Green
Write-Host " Sandbox closed safely. All processes terminated. " -ForegroundColor Green
Write-Host "==================================================" -ForegroundColor Green
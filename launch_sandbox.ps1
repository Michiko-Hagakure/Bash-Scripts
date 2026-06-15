# Make sure we are running as Administrator
$isAdmin = ([Security.Principal.WindowsPrincipal][Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)
if (-not $isAdmin) {
    Write-Error "Please run this script as Administrator! Right-click PowerShell and 'Run as Administrator'."
    Exit
}

# Define Sandbox Container Name
$CONTAINER_NAME = "Michiko_Secure_Sandbox"
# Using Server Core image
$IMAGE_NAME = "mcr.microsoft.com/windows/servercore:ltsc2022"

Write-Host "==================================================" -ForegroundColor Cyan
Write-Host " Starting Secure Windows Sandbox & Isolation Env by Michiko" -ForegroundColor Cyan
Write-Host "==================================================" -ForegroundColor Cyan
Write-Host "[+] Network: ISOLATED (none)" -ForegroundColor Yellow
Write-Host "[+] Processes: KERNEL ISOLATED (Hyper-V Isolation Mode)" -ForegroundColor Yellow
Write-Host "[+] Filesystem: LOCKED to Container Instance" -ForegroundColor Yellow
Write-Host "--------------------------------------------------"
Write-Host "Type 'exit' if finished testing."
Write-Host ""

# Run the Hardened Sandbox using Hyper-V Isolation
# --network none = Strips all network interfaces (Total air-gap)
# --isolation hyperv = Guarantees a dedicated kernel instance for the sandbox
docker run --rm -it --name $CONTAINER_NAME --network none --isolation=hyperv $IMAGE_NAME cmd.exe

Write-Host ""
Write-Host "==================================================" -ForegroundColor Green
Write-Host " Sandbox closed safely. All processes terminated. " -ForegroundColor Green
Write-Host "==================================================" -ForegroundColor Green
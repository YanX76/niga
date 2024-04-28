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
        $ProcessInfo = New-Object System.Diagnostics.ProcessStartInfo
        $ProcessInfo.FileName = "cmd.exe"
        $ProcessInfo.Arguments = "/c whoami /priv"
        $ProcessInfo.UseShellExecute = $false
        $ProcessInfo.RedirectStandardOutput = $true
        $Process = New-Object System.Diagnostics.Process
        $Process.StartInfo = $ProcessInfo
        $Process.Start() | Out-Null
        $Process.WaitForExit()

        $Output = $Process.StandardOutput.ReadToEnd()
        if ($Output -match "SeDebugPrivilege") {
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

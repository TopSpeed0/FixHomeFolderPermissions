function invoke-DisabledAclIn {
    param (
        [bool]$SetRootACL,
        [bool]$RemoveInheritedAccessRules,
        $logDir,
        $path
    )
    if ($RemoveInheritedAccessRules -eq $true) {}
    #0 remove Inheritance
    try {
        # Set-NTFSInheritance -Path $path -AccessInheritanceEnabled:$false -AuditInheritanceEnabled:$false -ErrorAction SilentlyContinue
        if ($RemoveInheritedAccessRules) {
            disable-NTFSAccessInheritance -Path $path -RemoveInheritedAccessRules:$true -ErrorAction Stop
        }  else {
            disable-NTFSAccessInheritance -Path $path -RemoveInheritedAccessRules:$false -ErrorAction Stop
        }
    }
    catch {
        $err_ = "$($_.Exception.Message)" 
        $err_ | Out-File $logDir -Append
        Write-error "x2 $err_"
    }
    finally {
        if (!$err_) {
            $log = "disable NTFS Access Inheritance ACL from:$path"
            # Write-host $log -ForegroundColor DarkBlue
            $log | Out-File $logdir -Append
        }
    }
}


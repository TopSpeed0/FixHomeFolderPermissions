function Remove-Acl {
    param (
        $RemoveACL,
        $logDir,
        $path,
        $AccessRights

    )
    $err_ = $null
    try { 
        $RemoveACL | remove-NTFSAccess -ErrorAction Stop
        #$RemoveACL | % { $_ | remove-NTFSAccess -ErrorAction Stop -Account $_.Account.AccountName -AccessRights $_.AccessRights }
    }
    catch {
        $err_ = "$($_.Exception.Message)" 
        $err_ | Out-File $logDir -Append
        Write-error "x9 $err_"
    }
    finally {
        if (!$err_) {
            $log = "Removing ACL:$($RemoveACL) AccessRights:$AccessRights AccessType:Allow Path:$path"
            # Write-host $log -ForegroundColor blue
            $log | Out-File $logDir -Append
        }
    } 
}

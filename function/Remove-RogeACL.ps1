
# Remove any roge ACL from the path
function Remove-RogeACL {
    param (
        [string]$logDir,
        [string]$path,
        [string]$domain,
        [string]$user,
        [bool]$root,
        $acls,
        $systemACL
    )

    "ACLs:$acls found in path:$path" | Out-File $logDir -Append 

    $RemoveACL = $acls | ? { $_.Account.AccountName -notin $systemACL.name }
    if ( $RemoveACL ) {
        try { 
            $RemoveACL | remove-NTFSAccess -ErrorAction Stop
            #$RemoveACL | % { $_ | remove-NTFSAccess -ErrorAction Stop -Account $_.Account.AccountName -AccessRights $_.AccessRights }
        }
        catch {
            $err_ = "$($_.Exception.Message)" 
            $err_ | Out-File $logDir -Append
            Write-error "x10 $err_"
        }
        finally {
            if (!$err_) {
                $log = "Removing ACL:$($RemoveACL) from Path:$path"
                # Write-host $log -ForegroundColor blue
                $log | Out-File $logDir -Append
            }
        }
    }
    if ($root -eq $false) {
        $acls = get-NTFSAccess -Path $path
        $IsInherited = $acls | ? { $_.IsInherited -eq $false }
        if ($IsInherited) {
            # $IsInherited | remove-NTFSAccess -ErrorAction Stop
            invoke-FixSystemACL -logDir $logdir\ -domain $domain -path $path -AccessRights "FullControl" -user $user -acls $IsInherited
        }
    }
} 

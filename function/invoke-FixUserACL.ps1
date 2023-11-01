# fix User ACL
function invoke-FixUserACL {
    param (
        [string]$logDir,
        [string]$path,
        [string]$AccessRights,
        [string]$user,
        [string]$domain,
        $acls


    )
    # Set User Domain 
    $ID = "$domain\$user"
    # get ACLs for the Corent folder from  $acls
    $acl = $acls | ? { $_.Account.AccountName -eq $ID }

    # if User Dont have Access 
    if ($acl) {
        foreach ($ac in $acl) {
            $err_ = $null
            try {
                $ac | remove-NTFSAccess -ErrorAction Stop
            }
            catch {
                $err_ = "$($_.Exception.Message)" 
                $err_ | Out-File $logDir -Append
                Write-error "x6 $err_"
            }
            finally {
                if (!$err_) {
                    $log = "Removing Curent ACL:$ac Account:$ID Path:$path"
                    # Write-host $log -ForegroundColor DarkGreen
                    $log | Out-File $logDir -Append
                }
            }
        }
    }
    # adding the Correct ACL
    $err_ = $null
    try { 
        Add-NTFSAccess -Account $ID -AccessRights $AccessRights -AccessType Allow -Path $path -ErrorAction Stop
    }
    catch {
        $err_ = "$($_.Exception.Message)" 
        $err_ | Out-File $logDir -Append
        Write-error "x7 $err_"
    }  
    finally {
        if (!$err_) {
            $log = "Adding ACL Account:$ID AccessRights:$AccessRights AccessType:Allow Path:$path"
            # Write-host $log -ForegroundColor DarkRed
            $log | Out-File $logDir -Append
        }
    }
}
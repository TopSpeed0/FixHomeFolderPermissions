function add-SystemACL {
    param (
        [string]$logDir,
        [string]$path,
        [string]$AccessRights,
        [string]$ID
    )
    $err_ = $null
    try { 
        Add-NTFSAccess -Account $ID -AccessRights $AccessRights -AccessType Allow  -Path $path -ErrorAction Stop
    }
    catch {
        $err_ = "$($_.Exception.Message)" 
        $err_ | Out-File $logDir -Append
        Write-error "x5 $err_"
    }
    finally {
        if (!$err_) {
            $log = "Adding ACL Account:$ID AccessRights:$AccessRights AccessType:Allow Path:$path"
            # Write-host $log -ForegroundColor Yellow
            $log | Out-File $logDir -Append
        }
    }
}
# fix System ACL

function invoke-FixSystemACL {
    param (
        [string]$logDir,
        [string]$path,
        [string]$AccessRights,
        [string]$domain,
        [string]$user,
        $acls,
        $systemACL
    )

    foreach ($system in $systemACL) {
        # Write-host "Test $($system.name) now on:$path " -ForegroundColor White -BackgroundColor DarkMagenta
        $acl = $null
        $acl = $acls | ? { $_.Account.AccountName -eq $system.name  }

        if ( !$acl ) {$option = "addAcl"} elseif ( $acl.AccessRights -ne $AccessRights ) {$option = "RemoveAclAdd"} else {
            $option = "default"
        }

        switch -wildcard ($option) 
        {
            "addAcl" {
                add-SystemACL -logDir $logDir -path $path -AccessRights $AccessRights -ID $system.name 
            }
            "RemoveAclAdd" {
                Remove-Acl -logDir $logDir -path $path -RemoveACL $acl -AccessRights $acl.AccessRights
                Start-Sleep -Milliseconds 10
                add-SystemACL -logDir $logDir -path $path -AccessRights $AccessRights -ID $system.name 
            }
            "Option3" {
            }
            default {
                $null
            }
        }
    }
}
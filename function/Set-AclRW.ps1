
function Set-AclRW {
    param (
        $path,
        $logDir,
        $user,
        $domain,
        $systemACL
    )
    $acls = get-NTFSAccess -Path $path

    # starting at root folder 
    #0 remove Inheritance
    invoke-DisabledAclIn -logDir "$logdir\$user.log" -path $path -RemoveInheritedAccessRules $false
    
    # fix owner
    Invoke-FixOwner -Account "BUILTIN\Administrators" -logDir "$logdir\$user.log" -path $path

    # fix the home folder ACL
    invoke-FixUserACL -logDir "$logdir\$user.log" -domain $domain -path $path -AccessRights "FullControl" -user $user -acls $acls 
    
    # Add necessary system ACL
    invoke-FixSystemACL -logDir "$logdir\$user.log" -domain $domain -path $path -AccessRights "FullControl" -user $user -acls $acls -systemACL $systemACL
    
    # Add necessary system ACL
    Remove-RogeACL -logDir "$logdir\$user.log" -domain $domain -path $path -user $user -acls $acls -root $true -systemACL $systemACL

    
    # loop # # enable Inheritance on all sub folders
    get-childItem -Recurse -Path $path | % { $cpath = $_.FullName ; $acls = get-NTFSAccess -Path $path
        # Remove Inheritance
        invoke-DisabledAclIn -logDir "$logdir\$user.log" -path $cpath -RemoveInheritedAccessRules $true

        # fix owner
        Invoke-FixOwner -Account "BUILTIN\Administrators" -logDir "$logdir\$user.log" -path $cpath

        # Remove any roge ACL from the path
        $acls = get-NTFSAccess -Path $cpath
        Remove-RogeACL -logDir "$logdir\$user.log" -domain $domain -path $cpath -user $user -acls $acls -root $false -systemACL $systemACL

        # Enable NTFS Access Inheritance
        invoke-EnableAclIn -Path $cpath -logDir "$logdir\$user.log"
    }
    # export final ACL Reports
    $Rights = Get-AclReport -Path $path -logDir "$logdir\$user.log"
    return $Rights
}
function Get-AclReport {
    param (
        $path,
        $logDir
    )
        $Rights = @()
        $Report = @()
        $PermFix = $true
        # export final ACL Reports
        $acl = Get-NTFSAccess -path $path
        $FileSystemRights = foreach ($ac in $Acl) { $ac | ? { $ac.Account -match $user.name } }
        $AccessRights = foreach ($Acl in $Acl) { "$($Acl.Account)" + " " + "$($Acl.AccessRights)" }
        $Count = $FileSystemRights.Count
        
        $Rights += New-Object psobject -property @{
            "User"           = $ID 
            "AccessRights"   = $AccessRights
            "UserNTFSRights" = $Count
            "PermFix"        = $PermFix 
        }

        $Rights.User | Out-File $logDir -Append
        $AccessRights = [pscustomobject]@{ AccessRights = (@($Rights.AccessRights) -join ',') }
        $AccessRights = $AccessRights.AccessRights
        $PermFix = $Rights.PermFix
    
        $Report += New-Object psobject -property @{
            "Name"          = $user
            "path"          = $path  
            "AccessRights"  = $AccessRights
            "PermFix"       = $PermFix
        }
        return $Report
}
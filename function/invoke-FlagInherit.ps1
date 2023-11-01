# fix acl Flag
function invoke-FlagInherit {
    param (
        $InheritFolder,
        $folder,
        $logDir
    )
     
    try {
        Get-Acl $InheritFolder | Set-Acl $folder
    }
    catch {
        $err_ = "$($_.Exception.Message)" 
        $err_ | Out-File $logDir -Append
        Write-error "x8 $err_"
    }
    finally {
        if (!$err_) {
            $log = "Set Folder:$folder with ACL from:$InheritFolder"
            # Write-host $log -ForegroundColor DarkYellow
            $log | Out-File $logDir -Append
        }
    }
}
function invoke-EnableAclIn {
    param (
        $logDir,
        $path
    )
    #0 remove Inheritance
    $err_ = $null
    try {
        Enable-NTFSAccessInheritance -Path $path
    }
    catch {
        $err_ = "$($_.Exception.Message)" 
        $err_ | Out-File $logDir -Append
        Write-error "x3 $err_"
    }
    finally {
        if (!$err_) {
            $log = "Set back IsInherited ACL from:$path"
            # Write-host $log -ForegroundColor Green
            $log | Out-File $logdir -Append
        }
    }
}


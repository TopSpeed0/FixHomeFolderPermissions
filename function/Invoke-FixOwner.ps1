function Invoke-FixOwner {
    param (
        $Account,
        $logDir,
        $path
    )
    $err_ = $null
    try { 
        set-NTFSOwner -Path $path -Account $Account -ErrorAction Stop
    }
    catch {
        $err_ = "$($_.Exception.Message)" 
        $err_ | Out-File $logDir -Append
        Write-error "x4 $err_"
    }
    finally {
        if (!$err_) {
            $log = "set NTFS Owner Path:$path -Account:$Account"
            # Write-host $log -ForegroundColor blue
            $log | Out-File $logDir -Append
        }
    } 
}
# Invoke-FixOwner -Account "BUILTIN\Administrators" -logDir $logDir -path $path
function Invoke-Report {
    param (
        $jobResults,
        $smtp,
        $Data,
        $subject,
        $to,
        $from,
        $PostContent,
        $ReportFile
    )

    # Create Meta Data
    $body = ConvertTo-Html -PreContent $data -PostContent $PostContent
    $body = (($body | Out-String) -replace "(?sm)<table>\s+</table>")
    $date001 = get-date -Format "dd/M/yyyy - HH:mm:ss"

    # filter Object if needed
    $jobResults = $jobResults | select-Object Name, path, PermFix, AccessRights

    # Create A file Report
    try {
        $jobResults | Export-Excel -WorksheetName "Fix Windows Home Folder" `
            -Path $ReportFile -TableStyle Medium2 -AutoSize:$true -TitleBold:$true -BoldTopRow:$true -FreezeTopRow:$true -ErrorAction Stop
    }
    catch {
        $err_ = "Export File Report to $ReportFile Failed with Error Message:$($_.Exception.Message)" 
        $err_ | Out-File $logDir -Append
        Write-error "x5 $err_"
    }
    finally {
        if (!$err_) {
            $log = "Export File Report to $ReportFile Successfully"
            # Write-host $log -ForegroundColor Yellow
            $log | Out-File $logDir -Append 
        }
    }

    # Send Mail
    $subject = $subject+$date001
    try {
        send-MailMessage  -SmtpServer $smtp -To $to -From $from -Subject $subject -Body $body -BodyAsHtml -Priority high -Attachments $ReportFile -ErrorAction Stop
    }
    catch {
        $err_ = "Failed to Send mail to To:$to From:$from with Subject $subject Error Message:$($_.Exception.Message)" 
        $err_ | Out-File $logDir -Append
        Write-error "x5 $err_"
    }
    finally {
        if (!$err_) {
            $log = "Send mail to To:$to From:$from with Subject $subject Successfully"
            # Write-host $log -ForegroundColor Yellow
            $log | Out-File $logDir -Append 
        }
    }
}

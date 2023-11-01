#Requires -Version 7
#Requires -RunAsAdministrator
#Requires -Modules NTFSSecurity
#Requires -Modules importExcel
Import-Module NTFSSecurity
Import-Module importExcel 
Clear-Host

# home folder path
$HomeFolderPath = "\\server\home"
$homefolders = Get-ChildItem $HomeFolderPath

# Domain Name
$domain = 'DomainNetBiosName'

# Mail Settings
$smtp = "Server-IP"
$subject = "FixACL: "
$from = "FixACL@domain.com"
$to = "xxx.xx@domain.com"
# mail Metadata
$data = "<h2>last HomeFolderFix batch</h2>"
$PostContent = "Attachments: Fix Windows Home Folder.xlsx "

# Starting Commands and logs
$CWD = [Environment]::CurrentDirectory
#$CWD = "C:\Scripts\FixHomeACL"
Set-Location $CWD
$Scriptspath = $CWD

# Log Settings
$newLogDirectory = "$Scriptspath\LOGs\" # log file Directory
$newLogDirectory = "$newLogDirectory\$(get-date -Format yyyy.dd.MM-hhmm)" 
mkdir $newLogDirectory -ErrorAction SilentlyContinue # set date directory log
$logDir = "$newLogDirectory\GeneralLog.log" # General log for the main proccess
$UserFolderLog = $newLogDirectory # each proccess will throw a user folder log base of the name of the folder on this directory

# Report File
$ReportFile = "$Scriptspath\Fix Windows Home Folder.xlsx"

################################################################################################################
## Main ##
################################################################################################################

# Define a script block for your processing logic
$scriptBlock = {
    param (
        $CWD,
        $username,
        $Fullname,
        # General Log , general errors
        $logDir,
        # for each homefolder a sprated log.
        $UserFolderLog,
        $domain
    )
    
    # Loading All Functions
    Set-Location $CWD
    "function" | ForEach-Object {
        Get-ChildItem -Path (Join-Path $CWD $_) -Filter '*.ps1' | ForEach-Object {
            $pathToFile = $_.FullName
            try {
                write-host "loading PS:$pathToFile" -ForegroundColor Yellow
                . $pathToFile
            }
            catch {
                Write-Error "0 Failed to import file $($pathToFile): $_"
            }
        }
    }

    $log = "$(get-date) | Start Working on User:$username HomeFolder Path:$Fullname" 
    write-host $log -ForegroundColor Black -BackgroundColor White
    $log | Out-File $logDir -Append

    # Start Working on user
    try {
        write-host "Set-AclRW -path $Fullname -user $username -logDir $UserFolderLog -domain $domain logfile:$logDir"
        $Rights = Set-AclRW -path $Fullname -user $username -logDir $UserFolderLog -domain $domain -ErrorAction
    }
    catch {
        $err_ = "$($_.Exception.Message)"
        $err_ | Out-File $logDir -Append
        Write-error "x1 $err_"
        # break
    }
    return $Rights
}

# Create a job for each item to parallelize the processing
$jobs = @()
# Start the loop on the Folder
foreach ( $user in $homefolders  ) {
    $Fullname = $user.FullName
    $username = $user.name
    $job = Start-Job -ScriptBlock $scriptBlock -ArgumentList $CWD,$username,$Fullname,$logDir,$UserFolderLog,$domain
    $jobs += $job
}

# Wait for all jobs to complete
$jobs | Wait-Job

# Receive the results from the completed jobs
$jobResults = $jobs | Receive-Job

# Clean up jobs
$jobs | Remove-Job

# Delete old Job.
Remove-Item $ReportFile -Force -ErrorAction SilentlyContinue

# Start Job Report
Invoke-Report -ReportFile $ReportFile -jobResults $jobResults -smtp $smtp -subject $subject -from $from -to $to -$data -PostContent $PostContent -logDir $logDir

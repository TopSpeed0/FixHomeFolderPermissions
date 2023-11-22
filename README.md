# Home Folder Permission fixer ( FixHomeFolderPermissions )

Welcome to the documentation for the Home Folder Permission fixer script. This script is designed to help you manage permissions for home folders in a Windows environment.

## Table of Contents
- [Overview](#overview)
- [Prerequisites](#prerequisites)
- [Install](#Install)
- [Usage](#usage)
- [Customization](#customization)
- [ParallelRunning](#ParallelRunning)
- [Troubleshooting](#troubleshooting)
- [Contributing](#contributing)
- [License](#license)

## Overview
The Home Folder Permission fixer is a PowerShell script that automates the process of setting permissions for home folders. It can be used in environments where you want to ensure that specific ACLs (Access Control Lists) are applied consistently to user home directories.

## Prerequisites
Before using the script, make sure you have the following prerequisites in place:

- Windows environment
- PowerShell (version 7.0 or higher)
- NTFSSecurity
- importExcel

# Install
install-Module NTFSSecurity
install-Module importExcel

Download the repository and work form the Directory.
you can Download the repository from: [https://github.com/TopSpeed0/FixHomeFolderPermissions.git](https://github.com/TopSpeed0/FixHomeFolderPermissions.git)

# Copy repository
gh repo clone TopSpeed0/FixHomeFolderPermissions
git clone https://github.com/TopSpeed0/FixHomeFolderPermissions.git

## Usage
To use the script, follow these steps:

1. Customize the script by setting the root directory and specifying the desired ACLs.
2. Run the script using PowerShell.

## Customization

in .\Invoke-HomeFolderAclFix.ps1
please overview all var's

# to change the default ACL fix change the PSObject
```powershell
# Default ACL are in top of the files
.\Invoke-HomeFolderAclFix.ps1
    $systemACL = @(
        [PSCustomObject]@{name = "BUILTIN\Administrators"},
        [PSCustomObject]@{name = "CREATOR OWNER"},
        [PSCustomObject]@{name = "NT AUTHORITY\SYSTEM"},
        [PSCustomObject]@{name = "$domain\$user"}
    )
```
## ParallelRunning

This script is designed to optimize performance by processing each folder in parallel. This means that it can handle multiple home folders simultaneously, improving efficiency, especially in situations with a large number of user directories.

The script will independently apply the specified permissions to each home folder, ensuring that it doesn't wait for one folder's processing to complete before moving on to the next one. Parallel execution is particularly beneficial when managing a significant number of user directories, as it speeds up the overall process.

Keep in mind that the degree of parallelism can be influenced by factors such as the system's resources and the number of processor cores available. This script is designed to take advantage of available system resources for faster execution.

Example:

```powershell
# Set the root directory and ACLs in the script
work with the Script location as it use $CWD, please CD to the Correct folder or set it in the script

# Run the script
.\Invoke-HomeFolderAclFix.ps1
```
## Troubleshooting
To Troubleshooting disable the Job and run the script outside of th script block

## Contributing
Any help is Welcome

## License
# Important Disclaimer

**Usage at Your Own Risk:** Please note that the use of this script is entirely at your discretion and responsibility. While the script is designed to automate the process of Managing home folder permissions, it is crucial to exercise caution when using it in a production environment.

**Test Environment:** It is highly recommended to thoroughly review the script and test it in a controlled, non-production environment before applying it to your actual home Folders. Running the script in a test environment helps identify any potential issues, ensures it aligns with your specific needs, and minimizes the risk of unintended consequences.

**Variable Consideration:** Before applying this script in a production environment, carefully review and adjust variables like `$rootDirectory` and `$aclList` to match your Organizational requirements. Failing to do so may lead to unintended consequences.

By using this script, you acknowledge that you understand and accept the risks associated with modifying permissions on file systems, and you are solely responsible for any outcomes that result from its usage. Always maintain backups and a recovery plan to address unforeseen issues.

Please take the time to review, test, and adapt this script as needed to suit your unique circumstances.

---



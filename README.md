# Home Folder Permission fixer ( FixHomeFolderPermissions )

Welcome to the documentation for the Home Folder Permission fixer script. This script is designed to help you manage permissions for home folders in a Windows environment.

## Table of Contents
- [Overview](#overview)
- [Prerequisites](#prerequisites)
- [Usage](#usage)
- [Customization](#customization)
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

# install
install-Module NTFSSecurity
install-Module importExcel

## Usage
To use the script, follow these steps:

1. Customize the script by setting the root directory and specifying the desired ACLs.
2. Run the script using PowerShell.

Example:

```powershell
# Set the root directory and ACLs in the script
work with the Script location as it use $CWD, please CD to the Correct folder or set it in the script

# Default ACL are in
.\function\invoke-FixSystemACL
    $systemACL = @(
        [PSCustomObject]@{name = "BUILTIN\Administrators"},
        [PSCustomObject]@{name = "CREATOR OWNER"},
        [PSCustomObject]@{name = "NT AUTHORITY\SYSTEM"},
        [PSCustomObject]@{name = "$domain\$user"}
    )
# you can add or remove each of them

# Run the script
.\Invoke-HomeFolderAclFix.ps1
